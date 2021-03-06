#!/bin/sh
set -ex
apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y php-cli zip unzip
hhvm --version
php --version

(
  cd $(mktemp -d)
  curl https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
)

use_polyfill=$(hhvm --php -r "echo HHVM_VERSION_ID < 42600 ? 'old' : 'new';")
if [ "$use_polyfill" = "old" ]; then
  rm src/fb_intercept.new.hh
else
  rm src/fb_intercept.hh
fi

runtime=$(hhvm --php -r "echo HHVM_VERSION_ID >= 40000 ? 'php' : 'hhvm';")
if [ "$runtime" = "hhvm" ]; then
  removetestfiles=$(hhvm --php -r "echo HHVM_VERSION_ID < 32800 ? 'yes' : 'no';")
  if [ "$removetestfiles" = "yes" ]; then
    # The tests won't typecheck and work, so we remove them.
    rm -r tests
    # hhvm-autoload needs to have a directory here, but it can be empty.
    mkdir tests
    # We can't install hacktest
    rm composer.json
    mv composer.old.json composer.json
  fi
  hhvm /usr/local/bin/composer install
else
  # Implicitly uses php
  composer install
fi

hh_client

runstests=$(hhvm --php -r "echo HHVM_VERSION_ID >= 32800 ? 'canruntests' : 'cannotruntests';")
if [ "$runstests" = "canruntests" ]; then
  vendor/bin/hacktest tests/
fi
