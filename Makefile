.DEFAULT_GOAL=test

.PHONY: help
help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: compile bindir ## build apps

.PHONY: compile
compile:
	stack build

.PHONY: test
test: stack-test bindir ## run bundled unit tests

.PHONY: stack-test
stack-test:
	stack test

.PHONY: clean
clean: ## clean stack work dir
	stack clean

.PHONY: clobber
clobber: ## remove everything not tracked by git
	git clean -fdx .

.PHONY: bindir
bindir:
	ln -sf $$(realpath --relative-to=. $$(stack path --local-install-root)/bin)
