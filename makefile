.PHONY: build test clean

COFFEE=./node_modules/.bin/coffee

test:
	$(COFFEE) test/test.coffee

clean:
	rm -rf ableton.js
