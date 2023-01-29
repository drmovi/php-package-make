
init:
	git init -b main
	git submodule add https://github.com/drmovi/php-microservice-make make
	git submodule update --init --recursive
	. ./make/make/init  && init

phpstan:
	./vendor/bin/phpstan analyse --memory-limit=2G --configuration=devconf/phpstan.neon --debug
	./vendor/bin/phpstan clear-result-cache

phpstan-baseline:
	./vendor/bin/phpstan analyse --memory-limit=2G --configuration=devconf/phpstan.neon --allow-empty-baseline --generate-baseline=devconf/phpstan-baseline.neon

psalm:
	./vendor/bin/psalm --config=./devconf/psalm.xml --update-baseline --set-baseline=psalm-baseline.xml --no-cache

psalm-baseline:
	./vendor/bin/psalm --config=./devconf/psalm.xml --update-baseline=psalm-baseline.xml --no-cache

test:
	./vendor/bin/phpunit --configuration ./phpunit.xml

test-with-clover-coverage:
	@php -dxdebug.mode=coverage ./vendor/bin/phpunit --configuration ./phpunit.xml --coverage-clover ./coverage/clover.xml

test-with-html-coverage:
	@php -dxdebug.mode=coverage ./vendor/bin/phpunit --configuration ./phpunit.xml --coverage-html ./coverage

microservice:
	@php artisan microservice:scaffold

remove-microservice:
	@php artisan microservice:remove

style-fix:
	./vendor/bin/pint

style-test:
	./vendor/bin/pint --test

lint: style-test phpstan psalm

pipeline: lint test test-with-clover-coverage


