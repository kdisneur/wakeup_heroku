#! /bin/bash

if [ $(($(date +%M) % 15 == 0)) -eq 1 ]; then
  source $OPENSHIFT_DATA_DIR/.environment
  cd $OPENSHIFT_REPO_DIR
  echo "$(date +%D-%T) -- ping starting" >> ${OPENSHIFT_RUBY_LOG_DIR}/crontab
  RAILS_ENV=production rake ping:all 2> ${OPENSHIFT_RUBY_LOG_DIR}/crontab
  echo "$(date +%D-%T) -- ping finished" >> ${OPENSHIFT_RUBY_LOG_DIR}/crontab
fi
