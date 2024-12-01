#!/bin/sh

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'bin/console' ]; then
  if [ ! -d composer.json ]; then
    # copy the created symfony project to the working directory
    cp -a "${SYMFONY_BUILD_PROJECT}/${SYMFONY_PROJECT_DIRECTORY_NAME}/." .
  fi

  if [ "$APP_ENV" != 'prod' ]; then
    composer install --prefer-dist --no-progress --no-interaction
  fi

  #setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
  #setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var

  # start symfony server
  if [ "$SG_SERVER_ENABLED" = true ]; then
    symfony server:ca:install
    symfony server:start
  fi
fi

exec docker-php-entrypoint "$@"
