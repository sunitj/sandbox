import requests
import os
import time
#from py2neo import neo4j
from py2neo import Graph
import sys

# Connect to graph and add constraints.
url = "http://localhost:{port}/db/data/".format(port=sys.argv[1])
graph = Graph(url)

graph.cypher.run("CREATE CONSTRAINT ON (t:Tweet) ASSERT t.id IS UNIQUE;")
graph.cypher.run("CREATE CONSTRAINT ON (u:User) ASSERT u.screen_name IS UNIQUE;")
graph.cypher.run("CREATE CONSTRAINT ON (h:Hashtag) ASSERT h.name IS UNIQUE;")
graph.cypher.run("CREATE CONSTRAINT ON (l:Link) ASSERT l.url IS UNIQUE;")
graph.cypher.run("CREATE CONSTRAINT ON (s:Source) ASSERT s.name IS UNIQUE;")

# Get Twitter bearer to pass to header.
TWITTER_BEARER = os.environ["TWITTER_BEARER"]

# URL parameters.
q = sys.argv[2]
count = 100
result_type = "recent"
lang = "en"
since_id = -1
base_url = "https://api.twitter.com/1.1/search/tweets.json?"

tries=0
while tries < 2880:
    try:
        # Build URL.
        url = base_url + "q={q}&count={count}&result_type={result_type}&lang={lang}&since_id={since_id}".format(q=q,count=count,result_type=result_type,lang=lang,since_id=since_id)
        # Send GET request.
        r = requests.get(url, headers = {"accept":"application/json","Authorization":"Bearer " + TWITTER_BEARER})

        # Keep status objects.
        tweets = r.json()["statuses"]

        if tweets:
            plural = "s." if len(tweets) > 1 else "."
            print("Found " + str(len(tweets)) + " tweet" + plural)
        else:
            print("No tweets found.\n")
            time.sleep(65)
            continue

        # Update since_id so we do not get tweets that were captured in the last API call.
        since_id = tweets[0].get('id')

        # Pass dict to Cypher and build query.
        query = """
        UNWIND {tweets} AS t

        WITH t
        ORDER BY t.id

        WITH t,
             t.entities AS e,
             t.user AS u,
             t.retweeted_status AS retweet

        MERGE (tweet:Tweet {id:t.id})
        SET tweet.text = t.text,
            tweet.created_at = t.created_at,
            tweet.favorites = t.favorite_count

        MERGE (user:User {screen_name:u.screen_name})
        SET user.name = u.name,
            user.location = u.location,
            user.followers = u.followers_count,
            user.following = u.friends_count,
            user.statuses = u.statusus_count,
            user.profile_image_url = u.profile_image_url

        MERGE (user)-[:POSTS]->(tweet)

        MERGE (source:Source {name:t.source})
        MERGE (tweet)-[:USING]->(source)

        FOREACH (h IN e.hashtags |
          MERGE (tag:Hashtag {name:LOWER(h.text)})
          MERGE (tag)-[:TAGS]->(tweet)
        )

        FOREACH (u IN e.urls |
          MERGE (url:Link {url:u.expanded_url})
          MERGE (tweet)-[:CONTAINS]->(url)
        )

        FOREACH (m IN e.user_mentions |
          MERGE (mentioned:User {screen_name:m.screen_name})
          ON CREATE SET mentioned.name = m.name
          MERGE (tweet)-[:MENTIONS]->(mentioned)
        )

        FOREACH (r IN [r IN [t.in_reply_to_status_id] WHERE r IS NOT NULL] |
          MERGE (reply_tweet:Tweet {id:r})
          MERGE (tweet)-[:REPLY_TO]->(reply_tweet)
        )

        FOREACH (retweet_id IN [x IN [retweet.id] WHERE x IS NOT NULL] |
            MERGE (retweet_tweet:Tweet {id:retweet_id})
            MERGE (tweet)-[:RETWEETS]->(retweet_tweet)
        )
        """

        # Send Cypher query to db.
        graph.cypher.run(query,tweets=tweets)
        print("Tweets added to graph!\n")
        time.sleep(60)

    except Exception as e:
        print(e)
        time.sleep(60)
        tries += 1
        continue
