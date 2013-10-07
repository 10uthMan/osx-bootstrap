#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# require sudo password
require_sudo

# install postgres
postgres=`brew list | grep postgres`
if [[ ! $postgres ]]; then
    echo ''
    echo '##### Installing Formula Postgres...'
    
    PYTHON=/usr/local/bin/python brew install postgres

    # update system
    sudo sysctl -w kern.sysv.shmmax=1610612736
    sudo sysctl -w kern.sysv.shmmin=1
    sudo sysctl -w kern.sysv.shmmni=256
    sudo sysctl -w kern.sysv.shmseg=64
    sudo sysctl -w kern.sysv.shmall=393216
    # make sure settings stay after restart
    sudo cp -rf $source_dir/templates/sysctl.conf /etc

    # setup postgres
    ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    initdb /usr/local/var/postgres -E utf8

    # brew installs
    brew install postgis

    # brew fixes
    brew unlink libxml2

    # install required gem
    sudo gem install pg
    
    # setup postgres
    createuser postgres -s

    # setup postgis
    createdb template_postgis
    createlang plpgsql template_postgis
    psql -d template_postgis -f /usr/local/Cellar/postgis/*/share/postgis/postgis.sql
    psql -d template_postgis -f /usr/local/Cellar/postgis/*/share/postgis/spatial_ref_sys.sql
fi