{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# LANGUAGE TemplateHaskell #-}
module House.Data (
  House(..)
  , Room(..)
  , livingroom
  , tInC
  , livingroomT
) where

import Control.Lens
import Control.Lens.TH

data Room = Room { _tInC :: Int
                 , _doorOpen :: Bool
                 , _lightOn :: Bool
                 , _heatingOn :: Bool }

data House = House { _livingroom :: Room
                   , _kitchen :: Room }

string = "Heyho"

makeLenses ''House

makeLenses ''Room

livingroomT :: Lens' House Int
livingroomT = livingroom . tInC

{-
tInC :: Lens' Room Int
tInC element_function (Room t doorOpen lightOn heatingOn) = (\t' -> Room t' doorOpen lightOn heatingOn) <$> (element_function t)
 -}

