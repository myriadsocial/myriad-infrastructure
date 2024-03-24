#!/bin/sh
URI="mongodb://root:password@localhost:27017/myriad?authSource=admin"
mongodump --uri=$URI
mongorestore dump/