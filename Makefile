bin        = $(shell npm bin)
lsc        = $(bin)/lsc
browserify = $(bin)/browserify
jsdoc      = $(bin)/jsdoc
uglify     = $(bin)/uglifyjs
VERSION    = $(shell node -e 'console.log(require("./package.json").version)')

dist:
	mkdir -p dist

dist/core.lambda.umd.js: compile dist
	$(browserify) lib/index.js --standalone folktale.core.lambda > $@

dist/core.lambda.umd.min.js: dist/core.lambda.umd.js
	$(uglify) --mangle - < $^ > $@

# ----------------------------------------------------------------------
bundle: dist/core.lambda.umd.js

minify: dist/core.lambda.umd.min.js

compile:

documentation: compile
	$(jsdoc) --configure jsdoc.conf.json

clean:
	rm -rf dist build

test: compile
	$(lsc) test/tap.ls

package: compile documentation bundle minify
	mkdir -p dist/core.lambda-$(VERSION)
	cp -r docs dist/core.lambda-$(VERSION)
	cp -r lib dist/core.lambda-$(VERSION)
	cp dist/*.js dist/core.lambda-$(VERSION)
	cp package.json dist/core.lambda-$(VERSION)
	cp README.md dist/core.lambda-$(VERSION)
	cp LICENCE dist/core.lambda-$(VERSION)
	cd dist && tar -czf core.lambda-$(VERSION).tar.gz core.lambda-$(VERSION)

publish: clean
	npm install
	npm publish

bump:
	node tools/bump-version.js $$VERSION_BUMP

bump-feature:
	VERSION_BUMP=FEATURE $(MAKE) bump

bump-major:
	VERSION_BUMP=MAJOR $(MAKE) bump


.PHONY: test
