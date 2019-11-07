{-# LANGUAGE OverloadedStrings, RecordWildCards #-}
-- | Script to generate dockerfiles. Obviously using Haskell.
--
-- If you have @cabal-env@ installed, do:
--
--     cabal-env microstache
--
module Main (main) where

import Control.Monad (forM_)
import Data.Aeson
import Text.Microstache (compileMustacheFile, renderMustache)

import qualified Data.Text.Lazy.IO as LT


params :: [(FilePath, Params)]
params =
    [ mk "8.8/Dockerfile" Stretch "8.8.1"
    ]
  where
    mk fp dist gv = (fp, Params dist gv)

main :: IO ()
main = do
    template <- compileMustacheFile "Dockerfile.template"
    forM_ params $ \(fp, p) -> do
        let contents = renderMustache template (toJSON p)
        LT.writeFile fp contents

-------------------------------------------------------------------------------
-- Data types
-------------------------------------------------------------------------------

data Distribution = Stretch
  deriving (Show)

instance ToJSON Distribution where
    toJSON Stretch = "stretch"

data Params = Params
    { pDistribution :: Distribution
    , pGhcVersion   :: String
    }
  deriving (Show)

instance ToJSON Params where
    toJSON Params {..} = object
        [ "distribution" .= pDistribution
        , "ghcVersion"   .= pGhcVersion
        ]
