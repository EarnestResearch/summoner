{-# LANGUAGE QuasiQuotes #-}

{- |
Copyright: (c) 2017-2019 Kowainik
SPDX-License-Identifier: MPL-2.0
Maintainer: Kowainik <xrom.xkov@gmail.com>

@.makefile@ file template.
-}

module Summoner.Template.Makefile
       ( makefileFile
       ) where

import NeatInterpolation (text)

import Summoner.Settings (Settings (..))
import Summoner.Tree (TreeFs (..))


-- | Creates a `Makefile` file from the given 'Settings'.
makefileFile :: Settings -> TreeFs
makefileFile Settings{..} = File "Makefile" makefileFileContent
  where
    tab :: Text
    tab = "\t"

    makefileFileContent :: Text
    makefileFileContent =
        [text|
.DEFAULT_GOAL=test

.PHONY: help
help: ## help
${tab}@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
${tab}${tab}| sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: compile code-style bindir ## build generated client

.PHONY: compile
compile:
${tab}stack build --fast

.PHONY: code-style
code-style: ## hlint and stylish
${tab}hlint -j app src test
${tab}find src -name '*.hs' | xargs stylish-haskell -i

.PHONY: test
test: stack-test code-style bindir ## run bundled unit tests

.PHONY: stack-test
stack-test:
${tab}stack test --fast

.PHONY: clean
clean: ## clean stack work dir
${tab}stack clean

.PHONY: clobber
clobber: ## remove everything not tracked by git
${tab}git clean -fdx .

.PHONY: bindir
bindir:
${tab}ln -sf $$(realpath --relative-to=. $$(stack path --local-install-root)/bin)
        |]
