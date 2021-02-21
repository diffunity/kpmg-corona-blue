import tweepy
import re
import json
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

    output = json.dumps(jsonfile, ensure_ascii=False, indent="\t")
    return output


if __name__ == '__main__':
    print(get_posts("@gjwlsdnr0115"))

# from __future__ import print_function
# import getopt
# import logging
# import os
# import sys
# # import traceback
# # third-party: `pip install tweepy`
# import tweepy

# # global logger level is configured in main()
# Logger = None

# # Generate your own at https://apps.twitter.com/app
# CONSUMER_KEY = "5QBfZ8fanPj4MKRZF033Aw1YL"
# CONSUMER_SECRET = "lR7BesIo0o6nqv1xF2JaBG4DjNbb1DzNCftDNLM5MhARAQcHJT"  '
# OAUTH_TOKEN = "1325976318962401280-yCyQ0vZtf0jU6en9ujGpD5yXqtL7DO"
# OAUTH_TOKEN_SECRET = "D4y80Cfmhbi8WB1tTBYqrseSZtBSL31Q6Vzi6Q9MnJBOE"

# # batch size depends on Twitter limit, 100 at this time
# batch_size=100

# def get_tweet_id(line):
#     '''
#     Extracts and returns tweet ID from a line in the input.
#     '''
#     (tagid,_timestamp,_sandyflag) = line.split('\t')
#     (_tag, _search, tweet_id) = tagid.split(':')
#     return tweet_id

# def get_tweets_single(twapi, idfilepath):

#     # process IDs from the file
#     with open(idfilepath, 'rb') as idfile:
#         for line in idfile:
#             tweet_id = get_tweet_id(line)
#             Logger.debug('get_tweets_single: fetching tweet for ID %s', tweet_id)
#             try:
#                 tweet = twapi.get_status(tweet_id)
#                 print('%s,%s' % (tweet_id, tweet.text.encode('UTF-8')))
#             except tweepy.TweepError as te:
#                 Logger.warn('get_tweets_single: failed to get tweet ID %s: %s', tweet_id, te.message)
#                 # traceback.print_exc(file=sys.stderr)
#         # for
#     # with

# def get_tweet_list(twapi, idlist):

#     # fetch as little metadata as possible
#     tweets = twapi.statuses_lookup(id_=idlist, include_entities=False, trim_user=True)
#     if len(idlist) != len(tweets):
#         Logger.warn('get_tweet_list: unexpected response size %d, expected %d', len(tweets), len(idlist))
#     for tweet in tweets:
#         print('%s,%s' % (tweet.id, tweet.text.encode('UTF-8')))

# def get_tweets_bulk(twapi, idfilepath):

#     # process IDs from the file
#     tweet_ids = list()
#     with open(idfilepath, 'rb') as idfile:
#         for line in idfile:
#             tweet_id = get_tweet_id(line)
#             Logger.debug('Enqueing tweet ID %s', tweet_id)
#             tweet_ids.append(tweet_id)
#             # API limits batch size
#             if len(tweet_ids) == batch_size:
#                 Logger.debug('get_tweets_bulk: fetching batch of size %d', batch_size)
#                 get_tweet_list(twapi, tweet_ids)
#                 tweet_ids = list()
#     # process remainder
#     if len(tweet_ids) > 0:
#         Logger.debug('get_tweets_bulk: fetching last batch of size %d', len(tweet_ids))
#         get_tweet_list(twapi, tweet_ids)

# def usage():
#     print('Usage: get_tweets_by_id.py [options] file')
#     print('    -s (single) makes one HTTPS request per tweet ID')
#     print('    -v (verbose) enables detailed logging')
#     sys.exit()

# def main(args):
#     logging.basicConfig(level=logging.WARN)
#     global Logger
#     Logger = logging.getLogger('get_tweets_by_id')
#     bulk = True
#     try:
#         opts, args = getopt.getopt(args, 'sv')
#     except getopt.GetoptError:
#         usage()
#     for opt, _optarg in opts:
#         if opt in ('-s'):
#             bulk = False
#         elif opt in ('-v'):
#             Logger.setLevel(logging.DEBUG)
#             Logger.debug("main: verbose mode on")
#         else:
#             usage()
#     if len(args) != 1:
#         usage()
#     idfile = args[0]
#     if not os.path.isfile(idfile):
#         print('Not found or not a file: %s' % idfile, file=sys.stderr)
#         usage()

#     # connect to twitter
#     auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
#     auth.set_access_token(OAUTH_TOKEN, OAUTH_TOKEN_SECRET)
#     api = tweepy.API(auth)

#     # hydrate tweet IDs
#     if bulk:
#         get_tweets_bulk(api, idfile)
#     else:
#         get_tweets_single(api, idfile)

# if __name__ == '__main__':
#     main(sys.argv[1:])
