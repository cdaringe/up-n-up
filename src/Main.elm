port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (..)
import Array exposing (..)
port scrollIdIntoView : String -> Cmd msg

type alias StepManifest =
  {
      bg: String,
      text: String,
      from: NonTerminatingStepEnum,
      yes: NonTerminatingStepEnum,
      no: NonTerminatingStepEnum,
      isFinal: Bool,
      id: String
  }

type NonTerminatingStepEnum = YUP
  | READY
  | NOPE
  | WHAT_DO_YOU_HATE_BIKES
  | YEP_I_HATE_BIKES
  | YOU_DONT_HATE_BIKES_ILL_SHOW_YOUfest
  | NO_YOU_WONT_SHOW_ME
  | NO_I_DONT_HATE_BIKES
  | I_DONT_HAVE_A_GREAT_BIKE


type Step = NonTerminatingStepEnum StepManifest

ready id = NonTerminatingStepEnum (StepManifest "orange" "ready to roll?" READY YUP NOPE False id)
yup id = NonTerminatingStepEnum (StepManifest "pink" "yee-ha! let's ride!" YUP YUP YUP True id)
hate_bikes id = NonTerminatingStepEnum (StepManifest "green" "what, do you hate bikes?" WHAT_DO_YOU_HATE_BIKES YUP YUP False id)
nope id = NonTerminatingStepEnum (StepManifest "purple" "no can do" NOPE WHAT_DO_YOU_HATE_BIKES YUP False id)

step_templates = [
    ready,
    hate_bikes,
    nope,
    yup
  ]

steps : Array Step
steps = Array.fromList (
    map2
    (\id stepMaker -> stepMaker id)
    (List.map String.fromInt (range 1 (List.length step_templates)))
    (step_templates)
  )

manifests = Array.map
  (
    \stp -> case stp of
    NonTerminatingStepEnum manifest -> manifest
  )
  steps

matchStepOnFrom: NonTerminatingStepEnum -> StepManifest -> Bool
matchStepOnFrom stepType s = stepType == s.from

getManifest:  NonTerminatingStepEnum -> Array StepManifest -> StepManifest
getManifest stepType mfs =
  let
    isMatch = matchStepOnFrom stepType
    match = (Array.get 0 (Array.filter isMatch mfs))
  in
    case match of
      Just manifest -> manifest
      _ -> StepManifest "" "" READY READY READY False "-1"

type alias Model =
    {
        step : Step
    }

init : ( Model, Cmd Msg )
init =
    ( {
        step = case (Array.get 0 steps) of
          Just i -> i
          Nothing -> ready "-1"
    }, Cmd.none )

type Msg
    = NoOp | ScrollToPane NonTerminatingStepEnum

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )
    ScrollToPane stepType -> (model, scrollIdIntoView (getManifest stepType manifests).id)


ifNotFinal: Bool -> List (Html Msg) -> List (Html Msg)
ifNotFinal isFinal content = if isFinal then [] else content

toStep: StepManifest -> Html Msg
toStep manifest =
  let
    { text, bg, isFinal, id, yes, no} = manifest
  in
    div [ Html.Attributes.id id, class "ready stepper", style "background-color" bg ] [
      h1 [] [ Html.text text ],
      div [ class "yup"] (ifNotFinal isFinal ([ button [ onClick (ScrollToPane yes)] [ Html.text "yup" ] ])),
      div [ class "nope"] (ifNotFinal isFinal ([ button [ onClick (ScrollToPane no)] [ Html.text "nope" ] ]))
    ]

step : Step -> Html Msg
step stp =
  case stp of
    NonTerminatingStepEnum manifest -> toStep manifest

view : Model -> Html Msg
view model =
  div [] (
    List.append
      [
        header [] [
          img [ src "/giphy.webp" ] []
          , h1 [] [ text "Up n' Up™" ]
          , h4 [] [ text "let's go biking!"]
        ],
        div [ class "wut info" ] [
          h1 [] [ text "what is it." ],
          p [] [ text "you. me. us.  biking!" ],
          p [] [ text "let's ride bikes at lunch." ]
        ],
        div [ class "when info" ] [
          h1 [] [ text "when is it." ],
          p [] [ text "wednesdays! noon. fair weather only." ]
        ],
        div [ class "where info" ] [
          h1 [] [ text "where is it." ],
          p [] [
            text "up a tiny little hill.",
            br [] [],
            br [] [],
            img [ src "/route.png", style "max-width" "70%" ] [],
            br [] [],
            a [ href "https://www.google.com/maps/dir/WeWork+920+SW+6th+Avenue,+Southwest+6th+Avenue,+Portland,+OR/Council+Crest+Park,+1120+SW+Council+Crest+Dr,+Portland,+OR+97239/@45.5094396,-122.7065734,14.45z/data=!4m19!4m18!1m10!1m1!1s0x54950bb032234cdd:0xef4eb440c44cbc69!2m2!1d-122.679193!2d45.5173353!3m4!1m2!1d-122.697894!2d45.5205851!3s0x54950a1e2f1d4659:0x5a849a0c3724af53!1m5!1m1!1s0x54950a3502121c57:0x6ef20dbf54e5b73b!2m2!1d-122.7079089!2d45.4986189!3e1", target "_blank" ] [ text "map!" ]
          ]
        ]
      ]
      (List.map step (Array.toList steps))
  )

main : Program () Model Msg
main =
  Browser.element
    { view = view
    , init = \_ -> init
    , update = update
    , subscriptions = always Sub.none
    }
