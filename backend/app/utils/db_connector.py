from config import CONFIG
import psycopg2 as pg
import boto3
import json
import datetime


class Connector:
    def __init__(self, schema="public"):
        self.db_config = self.db_config()
        self.database = self.db_config["database"]
        self.host = self.db_config["host"]
        self.port = self.db_config["port"]
        self.user = self.db_config["user"]
        self.password = self.db_config["password"]
        self.schema = schema

        self.connection = self.connect_database()
        # self.execution_date = datetime.utcnow().strftime('%Y-%m-%d')

    @staticmethod
    def db_config():
        client = boto3.client('s3')
        obj = client.get_object(Bucket=CONFIG['Database']['bucket'], Key=CONFIG['Database']['key'])
        db_config = json.loads(obj['Body'].read())

        return db_config

    def connect_database(self):
        con_pg = pg.connect(database=self.database,
                            host=self.host,
                            port=self.port,
                            user=self.user,
                            password=self.password,
                            options=f"-c search_path={self.schema}")
        con_pg.autocommit = True
        return con_pg

    def restore_connection(self):
        self.close_connection()
        self.connection = self.connect_database()

    def close_connection(self):
        self.connection.close()

    def execute_query(self, query):
        con_pg = self.connection
        cur = con_pg.cursor()
        cur.execute(query)
        return cur

    def upsert(self, table, columns_list, values_list, batch_size=10000, action_on_conflict='update'):
        values_list = list(set(values_list))
        length_index = len(values_list)
        start_index = 0
        queries = []
        while start_index < length_index:
            batch_values_list = values_list[start_index: start_index + batch_size]
            values = ','.join(batch_values_list)
            if action_on_conflict == 'update':
                query = f"""INSERT INTO {table} ({','.join(columns_list)})
                            VALUES {values}
                            ON CONFLICT ON CONSTRAINT {table}_unique
                            DO UPDATE
                            SET ({','.join(columns_list)}) = ({','.join(['excluded.' + x for x in columns_list])})
                         """
            elif action_on_conflict == 'nothing':
                query = f"""INSERT INTO {table} ({','.join(columns_list)})
                            VALUES {values}
                            ON CONFLICT ON CONSTRAINT {table}_unique
                            DO NOTHING;
                         """
            else:
                query = f"""INSERT INTO {table} ({','.join(columns_list)})
                            VALUES {values}
                            ON CONFLICT ON CONSTRAINT {table}_unique
                            DO UPDATE
                            SET ({','.join(columns_list)}) = ({','.join(['excluded.' + x for x in columns_list])})
                         """
            start_index += batch_size
            queries.append(query)

            for q in queries:
                self.execute_query(q)

    @staticmethod
    def values_query_formatter(values_list):
        format_str_values = ["NULL" if x is None else "'" + str(x).replace("'", "''") + "'" if x != '' else "'None'"
                             for
                             x in values_list]
        format_query_values_with_parenthesis = "(" + ','.join(format_str_values) + ")"
        return format_query_values_with_parenthesis


if __name__ == "__main__":
    connector = Connector()
    print(connector.db_config())
