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

use_hhvm_for_composer = "$(hhvm use_hhvm_for_composer.hh)"

if $use_hhvm_for_composer
then
  hhvm /usr/local/bin/composer install
else
  composer install
fi

hh_client

vendor/bin/hacktest tests/
