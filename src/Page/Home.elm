module Page.Home exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (i, a)
import Html.Attributes exposing (class, href)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Background as Background
import Skeleton
import Utils.Href exposing (toTwitter, toGithub)
import Json.Decode exposing (Decoder, Value, fail, field, string, list)
import Utils.Markdown as Markdown



-- MODEL


type Social
    = Twitter
    | Github


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
        [ viewTags me.tags
        , viewPhoto me.photo
        , description
        , viewSocial
        ]


viewTags : List String -> Element msg
viewTags tags =
    let
        chip txt =
            el
                [ padding 4
                , Font.size 16
                , Font.color <| rgb255 255 255 255
                , Border.rounded 4
                , Background.color <| rgb255 52 152 219
                ]
                (text txt)  
    in
    row [ spacing 5, centerX ] <| List.map chip tags


viewPhoto : String -> Element msg
viewPhoto src =
    image
        [ width <| px 128
        , Border.rounded 100
        , clip
        , centerX
        ]
        { src = src
        , description = ""
        }


viewSocial : Element msg
viewSocial =
    let
        link_ href_ icon =
            el []
                <| Element.html
                <| a [ href href_ ]
                    [ i [ class icon ] []
                    ]

        socialLink social =
            case social of
                Twitter ->
                    link_ toTwitter "fa fa-twitter"
                
                Github ->
                    link_ toGithub "fa fa-github"
                    
    in
    row [ centerX, spacingXY 15 0 ]
        [ socialLink Github
        , socialLink Twitter
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

