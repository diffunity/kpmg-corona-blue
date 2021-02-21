import boto3
import json

client = boto3.client('s3')
obj = client.get_object(Bucket='kpmg-ybigta', Key='config/twitter_config.json')
TWITTER_CONFIG = json.loads(obj['Body'].read())
