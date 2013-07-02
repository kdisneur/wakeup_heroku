#! /bin/bash

if [ $(($(date +%M) % 15 == 0)) -eq 1 ]; then
  source $OPENSHIFT_DATA_DIR/.environment
  cd $OPENSHIFT_REPO_DIR
  RAILS_ENV=production rake ping:all
fi
