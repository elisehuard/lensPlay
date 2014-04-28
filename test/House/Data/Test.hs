module Main where

import Test.HUnit hiding (test)
import Test.Framework.Providers.HUnit
import Test.Framework.TH
import Test.Framework
import House.Data
import Control.Lens

main =
  defaultMain [
    testGroup "Lens Test" [ testCase "view living room temperature" case_1, testCase "2" case_2]
    ]

house = House {_livingroom = Room { _tInC = 21, _doorOpen = False, _lightOn = True, _heatingOn = False },
               _kitchen = Room { _tInC = 20, _doorOpen = False, _lightOn = False, _heatingOn = False } }

case_1 = do 
           let livingroomTValue = view livingroomT house
           livingroomTValue @=? 21
case_2 = do 2 @=? 2
