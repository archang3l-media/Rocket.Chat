#!/bin/bash
set -x
set -euvo pipefail
IFS=$'\n\t'

# Requires Node.js version 4.x
# Do not run as root

DEPLOY_DIR=rocket.chat

### BUILD
meteor npm install

# on the very first build, meteor build command should fail due to a bug on emojione package (related to phantomjs installation)
# the command below forces the error to happen before build command (not needed on subsequent builds)
set NODE_OPTIONS=--max_old_space_size=4096
set TOOL_NODE_FLAGS:--max_old_space_size=4096
set +e
increase-memory-limit
meteor add rocketchat:lib
meteor build --server-only --directory $DEPLOY_DIR --allow-superuser

### RUN
cd $DEPLOY_DIR/bundle/programs/server
npm install
