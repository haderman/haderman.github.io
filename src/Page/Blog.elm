module Page.Blog exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (..)
import Html.Attributes exposing (..)



-- MODEL


type alias Model =
    { title : String }


init : String -> ( Model, Cmd Msg )
init title =
    ( Model title
    , Cmd.none
    )



-- UPDATE


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text "Blog!"
    -- viewContent model.title


viewContent : String -> Html msg
viewContent title =
    text title