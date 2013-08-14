#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# install mysql
mysql=`brew list | grep mysql`
if [[ ! $mysql ]]; then
    echo ''
    echo '##### Installing Formula MySQL...'
    brew install mysql
    brew install mysql-connector-c

    # link connector
    brew link --overwrite mysql-connector-c

    # setup mysql
    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi