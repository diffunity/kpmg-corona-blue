import tweepy
import re
import json
import requests
import time
from collections import OrderedDict

from twitter_config import TWITTER_CONFIG

def get_posts(account):
    consumer_key = TWITTER_CONFIG["consumer_key"]
    consumer_secret = TWITTER_CONFIG["consumer_secret"]
    access_token = TWITTER_CONFIG["access_token"]
    access_secret = TWITTER_CONFIG["access_secret"]
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.secure = True
    auth.set_access_token(access_token, access_secret)
    twitter_api = tweepy.API(auth)

    # INPUT_ACCOUNT = "@TheBlueHouseKR"
    INPUT_ACCOUNT = account
    statuses = twitter_api.user_timeline(screen_name=INPUT_ACCOUNT,
                                         count=200, include_rts=False,
                                         exclude_replies=True,
                                         tweet_mode="extended")
    jsonfile = OrderedDict()
    # media_files = set()
    for status in statuses:
        post_id = int(status.id)
        time = status.created_at.isoformat()
        text = status.full_text
        text = re.sub("http.+$[/s/n]?", "", text)
        image = ''
        # print(status.text.encode('utf-8'))

        try:
            media = status.entities.get('media', [])
            if len(media) > 0:
                image = media[0]['media_url']
        except:
            pass

        jsonfile[post_id] = {"time": time, "text": text, "image": image}

    output = jsonfile
    return output


if __name__ == '__main__':
    posts_result = get_posts("@gjwlsdnr0115")
    posts = dict(posts_result)

    request_url = "http://ec2co-ecsel-f2k8u3ar7ixb-1602496836.ap-northeast-2.elb.amazonaws.com:8000/emotion-check/"
    for key in posts:
        request_body = dict()
        request_body["project_type"] = "twitter"
        request_body["data"] = {"type": "text",
                                "create_date_time": str(posts[key]["time"]),
                                "content": str(posts[key]["text"])}

        r = requests.post(request_url + 'text', data=json.dumps(request_body))
        print(r.json())

        if len(posts[key]["image"]) > 0:
            request_body = dict()
            request_body["project_type"] = "twitter"
            request_body["data"] = {"type": "photo",
                                    "create_date_time": posts[key]["time"],
                                    "content": posts[key]["image"]}
            r = requests.post(request_url + 'image', data=json.dumps(request_body))
            print(r.json())

        time.sleep(2)
