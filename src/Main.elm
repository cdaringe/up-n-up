port module Main exposing (Flags, Model, Msg(..), getManifest, ifNotFinal, init, main, matchStepOnFrom, renderStep, scrollIdIntoView, update, view)

import Array exposing (..)
import BannerImage exposing (..)
import Browser
import Colors exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (decodeValue)
import List exposing (..)
import Process
import RollingList exposing (..)
import Step exposing (..)
import Task
import Tuple exposing (pair)


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
    { banner_images : RollingList BannerImage
    , step : Step
    , steps : Array Step
    }


type alias Flags =
    { steps : Array BaseStep
    }


delay : Int -> msg -> Cmd msg
delay time msg =
    Process.sleep (toFloat time)
        |> Task.perform (\_ -> msg)


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        banner_image =
            current_image images

        step_count =
            Array.length flags.steps

        steps_with_id =
            map2 pair (range 1 step_count) (Array.toList flags.steps)

        steps =
            Array.map
                (\( id, step ) ->
                    Step.Step
                        (Colors.select_bg_color id)
                        step.body
                        (Colors.select_text_color id)
                        step.key
                        (String.fromInt id)
                        step.options
                )
                (Array.fromList steps_with_id)
    in
    ( { banner_images = images
      , step =
            case Array.get 0 steps of
                Just i ->
                    i

                Nothing ->
                    ready
      , steps = steps
      }
    , delay banner_image.duration CycleBannerImage
    )


type Msg
    = NoOp
    | ScrollToPane String
    | CycleBannerImage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ScrollToPane target ->
            ( model, scrollIdIntoView (getManifest target model.steps).id )

        CycleBannerImage ->
            let
                rolling_list =
                    RollingList.roll model.banner_images

                next_img =
                    current_image rolling_list
            in
            ( { model | banner_images = rolling_list }, delay next_img.duration CycleBannerImage )


ifNotFinal : Bool -> List (Html Msg) -> List (Html Msg)
ifNotFinal isFinal content =
    if isFinal then
        []

    else
        content


renderStep : Step -> Html Msg
renderStep step =
    let
        { bg_color, text, text_color, from, id, options } =
            step
    in
    div [ Html.Attributes.id id, style "background-color" bg_color, style "color" text_color, class ("ready stepper__container " ++ bg_color) ]
        [ div
            [ class "stepper__content" ]
            ([ h1 [] [ Html.text text ] ]
                ++ List.map
                    (\link ->
                        div []
                            [ button [ onClick (ScrollToPane link.to) ] [ Html.text link.body ]
                            ]
                    )
                    options
            )
        ]


view : Model -> Html Msg
view model =
    div []
        (List.append
            (List.append
                [ header []
                    [ img [ src ("/" ++ String.fromInt (current_image model.banner_images).id ++ ".gif") ] []
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
                    (Array.map renderStep model.steps)
                )
            )
            [ div [ class "stepper info" ]
                [ h1 [] [ text "" ]
                ]
            ]
        )


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = \flags -> init flags
        , update = update
        , subscriptions = always Sub.none
        }
