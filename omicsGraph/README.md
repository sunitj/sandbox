# omicsGraph
The purpose of this repo is for me to try out Neo4j. The content of this repo has been shamelessly borrowed/inspired from the following awesome people.

* [Nicole White](https://github.com/nicolewhite/graphs_r_cool) - RNeo4j Tutorials
* [Nigel Small](https://github.com/nigelsmall/py2neo) - py2neo module
* [Max De Marzi](http://maxdemarzi.com/) - Neo4j

Thank You!

---

## Dependencies
* R version 3.1.2 "Pumpkin Helmet"
	* RNeo4j
	* igraph
* Python version 2.7.9
	* requests
	* py2neo version 2.0.2
* Neo4j version 2.1.6
* OS:

	![About my Mac](images/about_this_mac.png)

## Create your own Neo4j graph of Twitter data:

* Obtain a `consumer_key` and a `consumer_secret` by [registering](https://dev.twitter.com/apps) an application on twitter.
* Get a [bearer token](https://dev.twitter.com/docs/auth/application-only-auth), type the following in your terminal:

```
curl -XPOST -u consumer_key:consumer_secret 'https://api.twitter.com/oauth2/token?grant_type=client_credentials'
```

* Copy **just** the token from the output of the previous command and execute the following command

```
export TWITTER_BEARER="the twitter bearer returned from the previous line"
```

Start neo4j, taking note of which port you're running it on. If you're running at http://localhost:7474/db/data/, you can start populating the database with.

```
python collect_keyword.py 7474 omics
```
The first argument, 7474, is which port you're running neo4j on and the second argument, omics, is the keyword by which you want to search for tweets. You may run this command with a different keyword as many times as you wish. In my case, I used the port 2794, so the commands I used were:

```
python collect_keyword.py 2794 omics
python collect_keyword.py 2794 metagenomics
python collect_keyword.py 2794 rnaseq
python collect_keyword.py 2794 bioinformatics
```

---
