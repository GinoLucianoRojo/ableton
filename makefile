.PHONY: build test

COFFEE=./node_modules/.bin/coffee

build:
	$(COFFEE) -c ableton.coffee

test:
	$(COFFEE) test/test.coffee
