#!/bin/bash

set -eux

if [ "$GITBUCKET_DB_URL" -a "$GITBUCKET_DB_USER" -a "$GITBUCKET_DB_PASSWORD" ]; then
  cat > /gitbucket/database.conf <<-EOCONF
db {
  url = "$GITBUCKET_DB_URL"
  user = "$GITBUCKET_DB_USER"
  password = "$GITBUCKET_DB_PASSWORD"
}
EOCONF
fi

if [ -z ${GITBUCKET_OPTS+x} ]; then
  java -jar /usr/local/gitbucket/gitbucket.war
else
  java -jar /usr/local/gitbucket/gitbucket.war $GITBUCKET_OPTS
fi
