.PHONY: build test clean zip

COFFEE=./node_modules/.bin/coffee

ZIP=ableton.zip

test:
	$(COFFEE) test/test.coffee

clean:
	rm -rf ableton.js $(ZIP)

zip:
	git archive --format zip --output $(ZIP) master
