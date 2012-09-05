#!/bin/bash
curl http://localhost:5984/nosql-slimmed/_design/test/_view/sun?startkey=\\[\"@$1\"\\]\&endkey=\\[\"@$1\",\\{\\}\\]\&reduce=false
