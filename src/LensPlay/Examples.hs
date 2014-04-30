{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# LANGUAGE TemplateHaskell #-}
module LensPlay.Examples (
  House(..)
  , Room(..)
  , livingroom
  , name
  , tInC
  , tInF
  , lightOn
  , livingroomT
  , livingroomTInF
  , masterSwitch
) where

import Control.Lens
import Control.Lens.TH
import Control.Applicative ((<$>), (<*>))
import Data.Monoid

data Room = Room { _tInC :: Float
                 , _doorOpen :: Bool
                 , _lightOn :: Bool
                 , _heatingOn :: Bool }

data House = House {  _name :: String
                   , _livingroom :: Room
                   , _kitchen :: Room }

-- template haskell to generate convenience lenses
makeLenses ''House
makeLenses ''Room

livingroomT :: Lens' House Float
livingroomT = livingroom . tInC

tInF :: Lens' Room Float
-- float in fahrenheit to room
tInF t_fn (Room t doorOpen lightOn heatingOn) = wrap <$> t_fn (cToF t)
                                               where
                                                 wrap :: Float -> Room
                                                 wrap t' = Room (fToC t') doorOpen lightOn heatingOn

livingroomTInF :: Lens' House Float
livingroomTInF = livingroom . tInF

-- switch to lightOn and heatingOn
roomSwitch :: Traversal' Room Bool
roomSwitch fn (Room t doorOpen lightOn heatingOn)
  = Room t doorOpen <$> fn lightOn <*> fn heatingOn

rooms :: Traversal' House Room
rooms fn (House name room1 room2)
  = House name <$> fn room1 <*> fn room2

masterSwitch :: Traversal' House Bool
masterSwitch = rooms . roomSwitch

-- in masterswitch it makes sense to know if anything is on or not
instance Monoid Bool where
  mempty = False
  mappend a b = a || b

cToF :: Float -> Float
cToF c = c*9/5 + 32

fToC :: Float -> Float
fToC f = (f - 32) * 5/9

instance Show House where
  show (House name r1 r2) = "House " ++ name ++ " - livingroom: " ++ show r1 ++ " - kitchen: " ++ show r2

instance Show Room where
  show (Room t doorOpen lightOn heatingOn) = "Room: temperature " ++ show t ++ " door is open " ++ show doorOpen ++ " light is on " ++ show lightOn ++ " heating is on " ++ show heatingOn

-- simpler example

data Time = T { _hours :: Int, _mins :: Int }

mins :: Lens' Time Int
mins min_fn (T h m)
  = wrap <$> min_fn m
  where
    wrap :: Int -> Time
    wrap m' = T (h + quot m' 60) (mod m' 60)

instance Show Time where
  show (T h m) = show h ++ ":" ++ show m


