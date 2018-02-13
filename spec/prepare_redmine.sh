#!/usr/bin/env bash

set -e

REDMINE_VERSION="3.4.4"
DUMMY_PATH="spec/dummy"
DB_ADAPTER="postgresql"

function dummy_download {
  curl "http://www.redmine.org/releases/redmine-$REDMINE_VERSION.tar.gz" -o redmine.tar.gz
  tar xzf redmine.tar.gz
  mv "redmine-$REDMINE_VERSION" $DUMMY_PATH
}

function add_rys_gem {
  # echo "gem 'rys', path: '$(pwd)'" > "$DUMMY_PATH/Gemfile.local"
}

function generate_database_yml {
  ruby -ryaml -e "
    config = {
      'adapter' => '$DB_ADAPTER',
      'database' => 'test_rys',
      'host' => '127.0.0.1',
      'encoding' => 'utf8'
    }
    config = {
      'test' => config,
      'development' => config,
      'production' => config
    }
    File.write('config/database.yml', config.to_yaml)
  "
}

function bundle_install {
  bundle install --without xapian rmagick
}

function generate_secret_token {
  bundle exec rake generate_secret_token
}

function rake_migrate {
  bundle exec rake db:migrate
  bundle exec rake redmine:plugins:migrate
}

function rake_init {
  # bundle exec rake db:drop db:create
  rake_migrate
}

export RAILS_ENV="production"

if [[ -d "$DUMMY_PATH/app" ]]; then
  echo "Dummy application exist"
else
  dummy_download
  add_rys_gem

  pushd $DUMMY_PATH
    generate_database_yml
    bundle_install
    generate_secret_token
    rake_init
  popd
fi

pushd $DUMMY_PATH
  rake_migrate
popd
