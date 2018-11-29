module Page.Post exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (Html, h1, div, p, text)
import Html.Attributes exposing (..)
import Element exposing (Element)
import Skeleton



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


view : Model -> Skeleton.Details msg
view model =
    { title = model.title
    , kids = [ viewContent model.title model.postID ]
    }


viewContent : String -> String -> Element msg
viewContent title postID =
    Element.html <|
        div []
            [ h1 [] [ text "BLOG!" ]
            , p [] [ text <| "Post" ++ postID ]
            ]