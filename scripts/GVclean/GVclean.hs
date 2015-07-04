{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# LANGUAGE Arrows, NoMonomorphismRestriction #-}

module Main where

import Text.XML.HXT.Core
import System.Environment

import Data.List (intercalate)
import Data.List.Split
import Text.Regex (subRegex, mkRegex)

-- | XML helpers:
isTag :: ArrowXml a => String -> a XmlTree XmlTree
isTag tag = isElem >>> hasName tag

parseXML :: String -> IOStateArrow s b XmlTree
parseXML file = readDocument [ withValidate no
                             , withSubstDTDEntities no
                             , withRemoveWS yes
                             ] file

-- | Data types:
data Tok = Nob String | Sma String deriving (Show, Eq)

data Page = Page { leftcol :: [Tok]
                 , rightcol :: [Tok]
                 } deriving (Show, Eq)


-- | Parsing:
-- Tweakables:
middleX = 300
okFonts = ["2", "3"] -- font 4 sometimes has PoS info, but rare enough that it's not useful

getPages :: ArrowXml a => a XmlTree Page
getPages = deep (isTag "page") >>>
  proc p -> do
    lefts <- (listA (tokIfLeftIs (<middleX))) -< p
    rights <- (listA (tokIfLeftIs (>=middleX))) -< p
    returnA -< Page { leftcol=squeeze lefts
                    , rightcol=squeeze rights
                    }

toTok :: ArrowXml a => a XmlTree Tok
toTok = getChildren >>> deep elt2Tok
  where
    elt2Tok =
      ifA (hasName "b") (deep getText >>> arr Nob) (
        ifA (hasName "i") (constA " " >>> arr Sma)
          (deep getText >>> arr Sma))

tokIfLeftIs :: ArrowXml a => (Int -> Bool) -> a XmlTree Tok
tokIfLeftIs f =
  deep (isTag "text")
  >>> goodFont `guards` this
  >>> goodLeft `guards` this
  >>> toTok
  where
    goodFont = getAttrValue "font" >>> isA (\v -> v `elem` okFonts)
    goodLeft = getAttrValue "left" >>> isA (\v -> f (atoi v))
    atoi s = read s :: Int

-- | Printing nicely, regexing/cleaning:
squeeze [] = []
squeeze (Nob a:Nob b:tl) =
  squeeze (Nob (a++b):tl)
squeeze (Sma a:Sma b:tl) =
  squeeze (Sma (a++b):tl)
squeeze (hd:tl) =
  hd:squeeze tl

cleanTok s =
  let r = rm "\t"
        $ rm "^ +| +[IV]* *$"
        $ rm " *- *[sv]?[.]? *$"
        $ rm "\\[[^][]*\\]"
        $ rm "\\([^()]*\\)"
        $ rm "\\([^()]*\\)" s
  in
    subRegex (mkRegex "  +") r " "
  where
    rm bad from = subRegex (mkRegex bad) from ""

-- turn "a,b→c" into "a→c" and "b→c"
spreadTok ns ss =
  let nl = splitc ns
      sl = splitc ss
  in
    intercalate "\n" [ n++"\t"++s | n <- nl, s <- sl ]
  where
    splitc x = map cleanTok $ split (dropDelims . dropBlanks $ oneOf ",") $ subRegex (mkRegex "[0-9]\\)") x ","

uncolumn [] = []
uncolumn (p:ps) = leftcol p ++ rightcol p ++ uncolumn ps

prettyCol [] = []
prettyCol (Nob n:Sma s:tl) =
  spreadTok (cleanTok n) (cleanTok s) : prettyCol tl
prettyCol (_:tl) =        -- ignore off-by-ones (nothing useful there)
  prettyCol tl

-- | Startup:
main = do
  [src] <- getArgs
  result <- runX (parseXML src >>> getPages)
  putStrLn $ intercalate "\n\n" $ prettyCol $ uncolumn result

test = runX (parseXML "test.xml" >>> getPages)
