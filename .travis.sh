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

if $HHVM_VERSION == "HHVM_VERSION=4"
then
  composer install
else
  hhvm /usr/local/bin/composer
fi

hh_client

vendor/bin/hacktest tests/
