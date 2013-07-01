#! /bin/bash

if [ $(($(date +%M) % 15 == 0)) -eq 1 ]; then
  cd $OPENSHIFT_REPO_DIR
  RAILS_ENV=production rake ping:all
fi
