#!/bin/sh

set -ex

docker run --rm -it --env-file ./.env.test -v $PWD:/app melvinsembrano/mysql-copy sh
