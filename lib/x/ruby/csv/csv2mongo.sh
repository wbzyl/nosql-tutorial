#!/usr/bin/env bash

echo "import goog.csv ==> database: stock / collection: goog"
mongoimport --db stock --collection goog --type csv --file goog.csv --headerline

# http://www.mongodb.org/display/DOCS/Import+Export+Tools
#
# Example: Importing Interesting Types
#
# MongoDB supports more types that JSON does, so it has a special format
# for representing some of these types as valid JSON. For example, JSON
# has no date type. Thus, to import data containing dates, you structure
# your JSON like:
#
#   {"somefield" : 123456, "created_at" : {"$date" : 1285679232000}}
#
# Then mongoimport will turn the created_at value into a Date.
