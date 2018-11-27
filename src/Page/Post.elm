module Page.Post exposing
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
    { title : String
    , postID : String
    }



initModel : String -> String -> Model
initModel post title =
    { title = title
    , postID = post
    }


init : String -> String -> ( Model, Cmd Msg )
init post title =
    ( initModel post title, Cmd.none )



-- UPDATE


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text <| "Post" ++ model.postID
    -- viewContent model.title


viewContent : String -> Html msg
viewContent title =
    text title