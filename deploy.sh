#!/bin/bash

set -e
set -u
set -x

# Make sure the current ruby version is installed
export PATH="$HOME/.rbenv/bin:$PATH"
rbenv install $(cat .ruby-version) --skip-existing

bundle install --deployment
rake build

rsync -rlptODv --chmod o=rx --delete _site/ root@docker1.librewulf.dog:/data/www/oslers.us
#ssh web.oslers.us chown -R william:www-data /var/www-blog
