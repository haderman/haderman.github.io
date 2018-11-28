module Page.Blog exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (..)
import Html.Attributes exposing (..)
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


viewContent : String -> Html msg
viewContent title =
    div []
        [ h1 [] [ text "BLOG!" ]
        , p [] [ text "Lista de blogs" ]
        ]