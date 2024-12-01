#!/bin/sh

set -eu -o pipefail

# todo: use env var instead of $1
directory="$1"

if [ ! -d "$directory" ]; then
  mkdir -p "$directory"
fi

# Delete existing symfony project
rm -rf "$directory/symfony"
cd "$directory"

echo "Installation of symfony project with $SYMFONY_VERSION version"
symfony new symfony --no-git --version="$SYMFONY_VERSION"
