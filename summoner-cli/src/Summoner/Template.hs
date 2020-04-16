{- |
Copyright: (c) 2017-2019 Kowainik
SPDX-License-Identifier: MPL-2.0
Maintainer: Kowainik <xrom.xkov@gmail.com>

This module contains functions for the Haskell project template creation.
-}

module Summoner.Template
       ( createProjectTemplate
       ) where

import Summoner.Settings (Settings (..))
import Summoner.Template.Cabal (cabalFile)
import Summoner.Template.Doc (docFiles)
import Summoner.Template.GitHub (gitHubFiles)
import Summoner.Template.Haskell (haskellFiles)
import Summoner.Template.Makefile (makefileFile)
import Summoner.Template.Mempty (memptyIfFalse)
import Summoner.Template.Stack (stackFiles)
import Summoner.Tree (TreeFs (..), insertTree)


-- | Creating tree structure of the project.
createProjectTemplate :: Settings -> TreeFs
createProjectTemplate settings@Settings{..} = Dir
    (toString settingsRepo)
    (foldr insertTree generatedFiles settingsFiles)
  where
    generatedFiles :: [TreeFs]
    generatedFiles = concat
        [ cabal
        , stack
        , makefile
        , haskell
        , docs
        , gitHub
        ]

    cabal, stack :: [TreeFs]
    cabal = [cabalFile settings]
    stack = memptyIfFalse settingsStack $ stackFiles settings
    makefile = memptyIfFalse settingsMakefile $ [makefileFile settings]

    haskell, docs, gitHub :: [TreeFs]
    haskell = haskellFiles settings
    docs    = docFiles settings
    gitHub  = gitHubFiles settings
