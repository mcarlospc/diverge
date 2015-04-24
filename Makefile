################################################################################
# executables
################################################################################

NPM_CHECK=node_modules/.bin/npm-check
MVERSION=node_modules/.bin/mversion
MOCHA=node_modules/.bin//mocha
_MOCHA=node_modules/.bin//_mocha
COVERALLS=node_modules/.bin/coveralls
ISTANBUL=node_modules/.bin/istanbul
CODECLIMATE=node_modules/.bin/codeclimate

################################################################################
# variables
################################################################################

VERSION=`egrep -o '[0-9\.]{3,}' package.json -m 1`

################################################################################
# setup everything for development
################################################################################

setup:
	@npm install

################################################################################
# tests
################################################################################

# test code in nodejs
test:
	@$(MOCHA)

# test code and generates coverage
test.coverage:
	@$(ISTANBUL) cover $(_MOCHA)

# test code, generates coverage and startup a simple server
test.coverage.preview: test.coverage
	@cd coverage/lcov-report && python -m SimpleHTTPServer 8080

# test code, generates coverage and send it to coveralls and codeclimate
test.coverage.coveralls: test.coverage
	@$(CODECLIMATE) < coverage/lcov.info
	@cat coverage/lcov.info | $(COVERALLS)

################################################################################
# manages version bumps
################################################################################

bump.minor:
	@$(MVERSION) minor

bump.major:
	@$(MVERSION) major

bump.patch:
	@$(MVERSION) patch

################################################################################
# checking / updating dependencies
################################################################################

deps.check:
	@$(NPM_CHECK)

deps.upgrade:
	@$(NPM_CHECK) -u

################################################################################
# publish / re-publish
################################################################################

publish:
	git tag -a $(VERSION) -m "Releasing $(VERSION)"
	git push origin master --tags
	npm publish

################################################################################
# OTHERS
################################################################################

.PHONY: test
