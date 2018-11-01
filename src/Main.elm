port module Main exposing (Flags, Model, Msg(..), getManifest, ifNotFinal, init, main, matchStepOnFrom, scrollIdIntoView, toStep, update, view)

import Array exposing (..)
import Browser
import Colors exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (decodeValue)
import List exposing (..)
import Step exposing (..)


port scrollIdIntoView : String -> Cmd msg


matchStepOnFrom : String -> Step -> Bool
matchStepOnFrom target s =
    target == s.from


getManifest : String -> Array Step -> Step
getManifest target mfs =
    let
        isMatch =
            matchStepOnFrom target

        match =
            Array.get 0 (Array.filter isMatch mfs)
    in
    case match of
        Just manifest ->
            manifest

        _ ->
            ready


type alias Model =
    { step : Step
    , steps : Array Step
    }


type alias Flags =
    { steps : Array BaseStep
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        step_count =
            Array.length flags.steps

        steps_with_id =
            List (range 1 step_count) flags.steps

        steps =
            \[ id, step ] -> Step (Colors.select_bg_color step_count id) step.body (Array.get (modBy step_count id) color_combos).text step.key (String.fromInt id) step.options
    in
    ( { step =
            case Array.get 0 flags.steps of
                Just i ->
                    i

                Nothing ->
                    ready
      , steps = flags.steps
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | ScrollToPane String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToPane target ->
            ( model, scrollIdIntoView (getManifest target model.steps).id )


ifNotFinal : Bool -> List (Html Msg) -> List (Html Msg)
ifNotFinal isFinal content =
    if isFinal then
        []

    else
        content


toStep : Step -> Html Msg
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
            (Array.toList
                (Array.map toStep model.steps)
            )
        )


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = \flags -> init flags
        , update = update
        , subscriptions = always Sub.none
        }
