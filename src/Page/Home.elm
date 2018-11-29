module Page.Home exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Element exposing (..)
import Element.Border as Border
import Skeleton
import Json.Decode exposing (Decoder, Value, fail, field, string)



-- MODEL


type alias Me =
    { name : String
    , description : String
    }

type alias Model =
    { title : String
    , me : Me
    }


init : Json.Decode.Value -> String -> ( Model, Cmd Msg )
init value title =
    let
        me =
            case Json.Decode.decodeValue meDecoder value of
                Ok { name, description }  ->
                    Me name description      
            
                Err err ->
                    Me "" <| Debug.toString value
                    
    in
        ( Model title me, Cmd.none )
   


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
    , kids = [ viewContent model.title model.me ]
    }


viewContent : String -> Me -> Element msg
viewContent title me =
    column
        [ centerX
        , padding 20
        , spacingXY 0 20
        , Border.width 1
        , Border.rounded 4
        , Border.color <| rgb255 240 240 240
        ]
        [ row [ centerX ] [ text me.name ]
        , row [ centerX ] [ text me.description ]
        ]



-- DECODERS


meDecoder : Decoder Me
meDecoder =
    Json.Decode.field "me" <|
        Json.Decode.map2 Me
            (Json.Decode.field "name" Json.Decode.string)
            (Json.Decode.field "description" Json.Decode.string)

