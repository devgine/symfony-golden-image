#!/bin/sh

set -eu -o pipefail

directory="$1"

# Delete existing symfony project
rm -rf "$directory/symfony"
cd "$directory"

echo "Installation of symfony project with $SYMFONY_VERSION version"
symfony new symfony --no-git --version="$SYMFONY_VERSION"
