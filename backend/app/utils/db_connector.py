from config import CONFIG
import psycopg2 as pg
import boto3
import json


class Connector:
    def __init__(self):
        self.db_config = self.db_config()
        self.conn = self.connector()

    @staticmethod
    def db_config():
        client = boto3.client('s3')
        obj = client.get_object(Bucket=CONFIG['Database']['bucket'], Key=CONFIG['Database']['key'])
        db_config = json.loads(obj['Body'].read())

        return db_config

    def connector(self):
        cnn = pg.connect(**self.db_config)
        print(cnn)
        return cnn


if __name__ == "__main__":
    connector = Connector()
    print(connector)
