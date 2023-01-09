init: init-check allow-safe-plugins install-phpstan install-psalm install-php-insights install-pint install-laramicroservice git-init


init-check:
ifneq ($(force) , yes)
	@if [ -f "./.git/hooks/pre-commit" ]; then echo "pre-commit hook already installed, Remove it first" ; exit 1; fi
	@if [ -d "./devconf" ]; then echo "devconf directory already exists, Remove it first" ; exit 1; fi
endif

git-init:
	git init -b main
	@curl -o ./.git/hooks/pre-commit https://raw.githubusercontent.com/drmovi/devconf/main/pre-commit
	@chmod +x ./.git/hooks/pre-commit
	echo ".DS_Store" >> .gitignore && echo "/coverage" >> .gitignore
	git add .
	git commit -m "feat: add devconfs"

install-phpstan:
	@composer require --dev --no-interaction phpstan/phpstan phpstan/extension-installer nunomaduro/larastan:^2.0
	@mkdir -p microservices
	@mkdir -p devconf && rm -f devconf/phpstan.neon && rm -f devconf/phpstan-baseline.neon && touch devconf/phpstan.neon && touch devconf/phpstan-baseline.neon
	@curl -o devconf/phpstan.neon https://raw.githubusercontent.com/drmovi/devconf/main/phpstan.neon
	$(MAKE) phpstan-baseline

allow-safe-plugins:
	@composer config --no-plugins allow-plugins.phpstan/extension-installer true
	@composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true

phpstan:
	./vendor/bin/phpstan analyse --memory-limit=2G --configuration=devconf/phpstan.neon

phpstan-baseline:
	./vendor/bin/phpstan analyse --memory-limit=2G --configuration=devconf/phpstan.neon --allow-empty-baseline --generate-baseline=devconf/phpstan-baseline.neon

install-psalm:
	@composer require --dev --no-interaction vimeo/psalm
	@mkdir -p devconf && rm -f devconf/psalm.xml  && touch devconf/psalm.xml
	@curl -o devconf/psalm.xml https://raw.githubusercontent.com/drmovi/devconf/main/psalm.xml
	@composer require --dev --no-interaction psalm/plugin-laravel
	./vendor/bin/psalm-plugin enable -c ./devconf/psalm.xml psalm/plugin-laravel || true
	./vendor/bin/psalm -c ./devconf/psalm.xml --set-baseline=psalm-baseline.xml || true

psalm:
	./vendor/bin/psalm --config=./devconf/psalm.xml --update-baseline --set-baseline=psalm-baseline.xml --no-cache

psalm-baseline:
	./vendor/bin/psalm --config=./devconf/psalm.xml --update-baseline=psalm-baseline.xml --no-cache

install-php-insights:
	@composer require --dev --no-interaction nunomaduro/phpinsights
	@php artisan vendor:publish --provider="NunoMaduro\PhpInsights\Application\Adapters\Laravel\InsightsServiceProvider"

test:
	./vendor/bin/phpunit --configuration ./phpunit.xml

test-with-clover-coverage:
	@php -dxdebug.mode=coverage ./vendor/bin/phpunit --configuration ./phpunit.xml --coverage-clover ./coverage/clover.xml

test-with-html-coverage:
	@php -dxdebug.mode=coverage ./vendor/bin/phpunit --configuration ./phpunit.xml --coverage-html ./coverage

insights:
	@php artisan insights --no-interaction

insights-fix:
	@php artisan insights --no-interaction --fix

install-clockworks:
	composer require --dev itsgoingd/clockwork

install-debug-bar:
	composer require --dev barryvdh/laravel-debugbar

install-pint:
	composer require --dev laravel/pint

install-laramicroservice:
	composer require --dev drmovi/laramicroservice

microservice:
	@php artisan microservice:scaffold

style-fix:
	./vendor/bin/pint

style-test:
	./vendor/bin/pint --test

lint: style-test phpstan psalm

pipeline: lint test test-with-clover-coverage
