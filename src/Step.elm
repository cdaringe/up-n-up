module Step exposing (BaseStep, Step, StepLink, ready)

import Array exposing (..)
import Json.Decode as Decode
import List exposing (..)


type alias StepLink =
    { body : String
    , to : String
    }


type alias BaseStep =
    { key : String
    , body : String
    , options : List StepLink
    }


type alias Step =
    { bg_color : String
    , text : String
    , text_color : String
    , from : String
    , id : String
    , options : List StepLink
    }


ready =
    Step "orange" "ready to roll?" "" "" "" []
