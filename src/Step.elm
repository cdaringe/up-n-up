module Step exposing (BaseStep, Step(..), StepLink, StepManifest, StepType(..), ready)

import Array exposing (..)
import List exposing (..)


type StepType
    = YUP
    | READY
    | NOPE
    | WHAT_DO_YOU_HATE_BIKES
    | YEP_I_HATE_BIKES
    | YOU_DONT_HATE_BIKES_ILL_SHOW_YOUfest
    | NO_YOU_WONT_SHOW_ME
    | NO_I_DONT_HATE_BIKES
    | I_DONT_HAVE_A_GREAT_BIKE


type alias StepLink =
    { body : String
    , to : StepType
    }


type alias BaseStep =
    { key : String
    , body : String
    , options : List StepLink
    }


type alias StepManifest =
    { bg : String
    , text : String
    , from : StepType
    , yes : StepType
    , no : StepType
    , isFinal : Bool
    , id : String
    }


type Step
    = StepType StepManifest



-- steps : Array Step
-- steps =
--     Array.fromList
--         (map2
--             (\id stepMaker -> stepMaker id)
--             (List.map String.fromInt (range 1 (List.length step_templates)))
--             step_templates
--         )


ready =
    StepType (StepManifest "orange" "ready to roll?" READY YUP NOPE False "-1")
