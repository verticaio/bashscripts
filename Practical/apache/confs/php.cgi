#!/bin/sh
PHPRC=/var/www/php-cgi/test.az/php.ini
export PHPRC
export PHP_FCGI_MAX_REQUESTS=2000000
exec /usr/bin/php-cgi
