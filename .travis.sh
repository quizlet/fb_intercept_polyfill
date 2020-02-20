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
  hhvm /usr/local/bin/composer install
else
  removetestfiles=$(hhvm --php -r "echo HHVM_VERSION_ID < 32800 ? 'yes' : 'no';")
  if [ "$removetestfiles" = "yes" ]; then
    rm -r tests
    # We can't install hacktest
    composer install --no-dev
  else
    composer install
  fi
fi

hh_client

runstests=$(hhvm --php -r "echo HHVM_VERSION_ID >= 32800 ? 'canruntests' : 'cannotruntests';")
if [ "$runstests" = "canruntests" ]; then
  vendor/bin/hacktest tests/
fi
