module Main where

import Test.HUnit hiding (test)
import Test.Framework.Providers.HUnit
import Test.Framework.TH
import Test.Framework
import LensPlay.Examples
import Control.Lens

main =
  defaultMain [
    testGroup "Lens Tests" [ testCase "simple lens view" case_simple_view,
                            testCase "living rooom temperature" case_composed_view,
                            testCase "set living room temperature" case_composed_set,
                            testCase "living room temperature in fahrenheit" case_convert,
                            testCase "calculate with living room temperature in fahrenheit" case_access_converted ]
  , testGroup "Traversal Tests" [testCase "view master switch of the house" case_traversal_switch,
                                 testCase "set master switch to false" case_set_traversal_switch,
                                 testCase "check if individual light is of after switching off the house" case_check_traversal_switch,
                                 testCase "check individual components of traversal" case_check_traversal_switch_2]
    ]

house = House {_name = "The Mansion",
               _livingroom = Room { _tInC = 21, _doorOpen = False, _lightOn = True, _heatingOn = False },
               _kitchen = Room { _tInC = 20, _doorOpen = False, _lightOn = False, _heatingOn = False } }

case_simple_view = (view name house  @=? "The Mansion")

case_composed_view = do 
                        let livingroomTValue = view livingroomT house
                        livingroomTValue @=? 21

case_composed_set = do let new_house = set livingroomT 22.0 house
                           newLivingroomTValue = view livingroomT new_house
                       newLivingroomTValue @=? 22

case_convert = do let livingroomTValueInF = view livingroomTInF house
                  livingroomTValueInF @=? 69.8

case_access_converted = do let new_house = over livingroomTInF (+ 3) house
                               livingroomTValueInF = view livingroomTInF new_house
                           livingroomTValueInF @=? 72.8

case_traversal_switch = do view masterSwitch house @=? True

case_set_traversal_switch = do let new_house = set masterSwitch False house
                               view masterSwitch new_house @=? False

case_check_traversal_switch = do let new_house = set masterSwitch False house
                                 view (livingroom . lightOn) new_house @=? False

case_check_traversal_switch_2 = toListOf masterSwitch house @=? [True, False, False, False]
