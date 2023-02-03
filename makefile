
init:
	@git init -b main
	@git submodule add --force https://github.com/drmovi/php-microservice-make make
	@git submodule update --init --recursive
	@. ./make/init  && init

phpstan:
	@. ./make/init  && phpstan

phpstan-baseline:
	@. ./make/init  && phpstan_baseline

psalm:
	@. ./make/init  && psalm

psalm-baseline:
	@. ./make/init  && psalm_baseline

test:
	@. ./make/init  && test

test-with-clover-coverage:
	@. ./make/init  && test_with_clover_coverage

test-with-html-coverage:
	@. ./make/init  && test_with_html_coverage

package:
	@./vendor/bin/dpg package:$(filter-out $@,$(MAKECMDGOALS))

style-fix:
	@. ./make/init  && style_fix

style-check:
	@. ./make/init  && style_check

lint: style-test phpstan psalm

pipeline: lint test test-with-clover-coverage


artisan:
	@. ./make/init  && artisan $(filter-out $@,$(MAKECMDGOALS))

