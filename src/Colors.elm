module Colors exposing (ColorCombo, color_combos, select_bg_color)

import Array
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
        [ ( "FBFBFA", "white" )
        , ( "CAD593", "white" )
        , ( "637B58", "white" )
        , ( "212C0F", "white" )
        , ( "1EACC3", "white" )
        , ( "F2454B", "white" )
        , ( "F5B634", "white" )
        , ( "E9F1DF", "white" )
        , ( "54D9CD", "white" )
        , ( "36B1BF", "white" )
        ]


select_bg_color : Int -> Int -> String
select_bg_color count index =
    case Array.get (modBy count index) (Array.fromList color_combos) of
        Just i ->
            i.bg

        Nothing ->
            ""
