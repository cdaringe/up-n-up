module Colors exposing (ColorCombo, color_combos, select_bg_color, select_text_color)

import Array
import Debug exposing (..)
import List exposing (..)


type alias ColorCombo =
    { bg : String
    , text : String
    }


color_combos =
    List.map
        (\( a, b ) ->
            ColorCombo a b
        )
        [ ( "#FBFBFA", "black" )
        , ( "#CAD593", "black" )
        , ( "#637B58", "white" )
        , ( "#212C0F", "white" )
        , ( "#1EACC3", "white" )
        , ( "#F2454B", "white" )
        , ( "#F5B634", "white" )
        , ( "#E9F1DF", "black" )
        , ( "#54D9CD", "white" )
        , ( "#36B1BF", "white" )
        ]


select_bg_color : Int -> String
select_bg_color index =
    let
        x =
            modBy (length color_combos) index
    in
    case Array.get x (Array.fromList color_combos) of
        Just i ->
            i.bg

        Nothing ->
            "red"


select_text_color index =
    let
        x =
            modBy (length color_combos) index
    in
    case Array.get x (Array.fromList color_combos) of
        Just i ->
            i.text

        Nothing ->
            "white"
