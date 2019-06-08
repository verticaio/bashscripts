#!/bin/bash

## Define the path for the mongodump
MONGODUMP_PATH="/usr/bin/mongodump"

## Define variables for mongodb backup
MONGO_PORT="27017"
MONGO_DB=(Array List)
MONGO_EXCLUDE_COLLECTION=(Array Exclude Collection)

MONGO_USERNAME="Username"
MONGO_PASSWORD="Password"
MONGO_AUTH_DB="Auth_DB"

TIMESTAMP=`date +%F`
EXCLUDE_VARIABLE=""

## Create a for loop depending the collection array elements you don't want to include
for c in ${MONGO_EXCLUDE_COLLECTION[@]}
do
  EXCLUDE_VARIABLE+=" --excludeCollection=$c"
done

## Create Backup for the mongodb components you want
for d in ${MONGO_DB[@]}
do
  $MONGODUMP_PATH --db $d $EXCLUDE_VARIABLE -u $MONGO_USERNAME -p $MONGO_PASSWORD --authenticationDatabase=$MONGO_AUTH_DB
done

## Define variables for S3
S3_BUCKET_NAME="S3_Bucket_Name"
S3_BUCKET_PATH="Custom_Path"

# Add timestamp to backup and then create a backup folder with hostname-timestap
mv dump mongodb-$HOSTNAME-$TIMESTAMP
tar -zcf mongodb-$HOSTNAME-$TIMESTAMP.tar.gz mongodb-$HOSTNAME-$TIMESTAMP

# To diminish the size of the backups, lets delete the folders after creating the backup file
rm -Rf $HOME/dump
rm -Rf $HOME/mongodb-$HOSTNAME-$TIMESTAMP

## You need to have a AWS Cli Installed and configured

aws s3 cp mongodb-$HOSTNAME-$TIMESTAMP.tar.gz s3://$S3_BUCKET_NAME/$S3_BUCKET_PATH/mongodb-$HOSTNAME-$TIMESTAMP.tar.gz --acl private

# After upload the file then we are going to eliminate the backup compressed file
rm mongodb-$HOSTNAME-$TIMESTAMP.tar.gz
