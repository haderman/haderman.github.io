module Page.Home exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Background as Background
import Skeleton
import Json.Decode exposing (Decoder, Value, fail, field, string, list)
import Utils.Markdown as Markdown



-- MODEL


type alias Me =
    { name : String
    , photo : String
    , tags : List String
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
                Ok { name, photo, tags, description }  ->
                    Me name photo tags description      
            
                Err err ->
                    Me "" "" [] ""
                    
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
    let
        name =
            paragraph [ centerX, Font.size 24, Font.bold ] [ text me.name ]

        tagsPanel =
            let
                chip txt =
                    el
                        [ padding 4
                        , Font.size 16
                        , Border.rounded 4
                        , Background.color <| rgb255 200 200 200
                        ]
                        (text txt)  
            in
            row [ spacing 5, centerX ] <| List.map chip me.tags

        photo =
            image
                [ width <| px 128
                , Border.rounded 100
                , clip
                , centerX
                ]
                { src = me.photo
                , description = ""
                }

        description =
            paragraph [ centerX, Font.size 20]
                [ Element.html <| Markdown.block me.description ]
                
    in
    column
        [ centerX
        , width (fill |> maximum 600)
        , padding 20
        , spacingXY 0 30
        ]
        [ tagsPanel
        , photo
        , description
        ]



-- DECODERS


meDecoder : Decoder Me
meDecoder =
    field "me" <|
        Json.Decode.map4 Me
            (field "name" string)
            (field "photo" string)
            (field "tags" <| list string)
            (field "description" string)

