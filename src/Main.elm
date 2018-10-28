port module Main exposing (Model, Msg(..), getManifest, ifNotFinal, init, main, manifests, matchStepOnFrom, scrollIdIntoView, toStep, update, view)

import Array exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (..)
import Step exposing (..)
import JSON exposing (..)


port scrollIdIntoView : String -> Cmd msg


manifests =
    Array.map
        (\stp ->
            case stp of
                StepType manifest ->
                    manifest
        )
        (Array.fromList [])


matchStepOnFrom : StepType -> StepManifest -> Bool
matchStepOnFrom stepType s =
    stepType == s.from


getManifest : StepType -> Array StepManifest -> StepManifest
getManifest stepType mfs =
    let
        isMatch =
            matchStepOnFrom stepType

        match =
            Array.get 0 (Array.filter isMatch mfs)
    in
    case match of
        Just manifest ->
            manifest

        _ ->
            StepManifest "" "" READY READY READY False "-1"


type alias Model =
    { step : Step
    }


type alias Flags =
    { steps : List BaseStep
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { step =
            case Array.get 0 Array.empty of
                Just i ->
                    i

                Nothing ->
                    ready
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | ScrollToPane StepType


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToPane stepType ->
            ( model, scrollIdIntoView (getManifest stepType manifests).id )


ifNotFinal : Bool -> List (Html Msg) -> List (Html Msg)
ifNotFinal isFinal content =
    if isFinal then
        []

    else
        content


toStep : StepManifest -> Html Msg
toStep manifest =
    let
        { text, bg, isFinal, id, yes, no } =
            manifest
    in
    div [ Html.Attributes.id id, class "ready stepper", style "background-color" bg ]
        [ h1 [] [ Html.text text ]
        , div [ class "yup" ] (ifNotFinal isFinal [ button [ onClick (ScrollToPane yes) ] [ Html.text "yup" ] ])
        , div [ class "nope" ] (ifNotFinal isFinal [ button [ onClick (ScrollToPane no) ] [ Html.text "nope" ] ])
        ]


step : Step -> Html Msg
step stp =
    case stp of
        StepType manifest ->
            toStep manifest


view : Model -> Html Msg
view model =
    div []
        (List.append
            [ header []
                [ img [ src "/giphy.webp" ] []
                , h1 [] [ text "Up n' Up™" ]
                , h4 [] [ text "let's go biking!" ]
                ]
            , div [ class "wut info" ]
                [ h1 [] [ text "what is it." ]
                , p [] [ text "you. me. us.  biking!" ]
                , p [] [ text "let's ride bikes at lunch." ]
                ]
            , div [ class "when info" ]
                [ h1 [] [ text "when is it." ]
                , p [] [ text "wednesdays! noon. fair weather only." ]
                ]
            , div [ class "where info" ]
                [ h1 [] [ text "where is it." ]
                , p []
                    [ text "up a tiny little hill."
                    , br [] []
                    , br [] []
                    , img [ src "/route.png", style "max-width" "70%" ] []
                    , br [] []
                    , a [ href "https://www.google.com/maps/dir/WeWork+920+SW+6th+Avenue,+Southwest+6th+Avenue,+Portland,+OR/Council+Crest+Park,+1120+SW+Council+Crest+Dr,+Portland,+OR+97239/@45.5094396,-122.7065734,14.45z/data=!4m19!4m18!1m10!1m1!1s0x54950bb032234cdd:0xef4eb440c44cbc69!2m2!1d-122.679193!2d45.5173353!3m4!1m2!1d-122.697894!2d45.5205851!3s0x54950a1e2f1d4659:0x5a849a0c3724af53!1m5!1m1!1s0x54950a3502121c57:0x6ef20dbf54e5b73b!2m2!1d-122.7079089!2d45.4986189!3e1", target "_blank" ] [ text "map!" ]
                    ]
                ]
            ]
            (List.map step [])
        )


main : Program JSON Model Msg
main =
    Browser.element
        { view = view
        , init = \flags -> init flags
        , update = update
        , subscriptions = always Sub.none
        }
