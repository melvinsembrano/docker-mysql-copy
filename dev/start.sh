#!/bin/sh

set -ex

DIR=$(dirname $0)

docker run --rm -it --env-file $DIR/.env.test -v $PWD:/app melvinsembrano/mysql-copy sh
