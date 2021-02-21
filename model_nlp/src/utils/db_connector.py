from config import CONFIG
import psycopg2.extras
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
        con_pg = psycopg2.connect(database=self.database,
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
        cur = con_pg.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(query)
        return cur

    def upsert_query(self, table, columns_list, values, action_on_conflict='update'):
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

        return query

    def insert_query(self, table, columns_list, values):
        query = f"""INSERT INTO {table} ({','.join(columns_list)})
                    VALUES {values}
                    RETURNING id
                 """

        return query

    def update_status_query(self, table, request_id, status):
        query = f"""
        UPDATE {table} SET status = {status} 
        WHERE id = {request_id}
        """
        return query

    def get_data_query(self, table, request_id):
        query = f"""SELECT * 
                    FROM {table}
                    WHERE id = {request_id}
        """

        return query

    @staticmethod
    def values_query_formatter(values_list):
        format_str_values = []
        for x in values_list:
            if type(x) == type(dict()):
                format_str_values.append("'" + str(x).replace("'", '"') + "'")
            else:
                format_str_values.append("'" + str(x).replace("'", "''") + "'")

        format_query_values_with_parenthesis = "(" + ','.join(format_str_values) + ")"
        return format_query_values_with_parenthesis


if __name__ == "__main__":
    connector = Connector()
    query = connector.get_data_query("job_call", 1)
    r = connector.execute_query(query)
    result = r.fetchall()[0]
    print(result)
    print(dict(result))