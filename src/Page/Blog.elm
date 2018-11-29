module Page.Blog exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Element exposing (..)
import Element.Border as Border
import Skeleton



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


view : Model -> Skeleton.Details msg
view model =
    { title = model.title
    , kids = [ viewContent model.title ]
    }


viewContent : String -> Element msg
viewContent title =
    column
        [ centerX
        , padding 20
        , spacingXY 0 20
        , Border.width 1
        , Border.rounded 4
        , Border.color <| rgb255 240 240 240
        ]
        [ row [ centerX ] [ text "BLOG PAGE" ]
        , row [ centerX ] [ text "En construccion" ]
        ]