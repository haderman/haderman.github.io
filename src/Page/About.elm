module Page.About exposing
  ( Model
  , init
  , Msg
  , update
  , view
  )


import Html exposing (i, a, div)
import Html.Attributes exposing (class, href)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Background as Background
import Skeleton
import Utils.Href exposing (toTwitter, toGithub, toCodepen)
import Json.Decode exposing (Decoder, Value, fail, field, string, list)
import Utils.Markdown as Markdown



-- MODEL


type Social
    = Twitter
    | Github
    | Codepen


type alias Job =
    { startedAt : String
    , finishedAt : String
    , tags : List String
    , client : String
    , position : String
    , responsabilities : List String
    }


type alias Me =
    { name : String
    , photo : String
    , tags : List String
    , description : String
    }


type alias Model =
    { title : String
    , me : Me
    , jobs : List Job
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

        jobs =
            case Json.Decode.decodeValue jobsDecoder value of
                Ok jobs_ ->
                    jobs_
            
                Err err ->
                    []
                    
    in
    ( Model title me jobs, Cmd.none )
   


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
    , kids = [ viewContent model.title model.me model.jobs ]
    }


viewContent : String -> Me -> List Job -> Element msg
viewContent title me jobs =
    let
        name =
            paragraph [ centerX, Font.size 24, Font.bold ] [ text me.name ]

        description =
            paragraph [ centerX, Font.size 20]
                [ Element.html <| Markdown.block me.description ]
            
    in
    column
        [ centerX
        , width fill
        , spacingXY 0 30
        , padding 20
        ]
        [ viewTags me.tags
        , viewPhoto me.photo
        , description
        , viewSocial
        , viewJobs jobs
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
    wrappedRow [ spacing 5, centerX ] <| List.map chip tags


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

                Codepen ->
                    link_ toCodepen "fa fa-codepen"
                    
    in
    row [ centerX, spacingXY 15 0 ]
        [ socialLink Github
        , socialLink Twitter
        , socialLink Codepen
        ]


viewJobs : List Job -> Element msg
viewJobs jobs =
    column [ width fill, spacingXY 0 20 ] <| List.map viewJob jobs


viewJob : Job -> Element msg
viewJob job =
    row [ width fill ]
        [ viewJobDuration job.startedAt job.finishedAt
        , viewJobDetails job.client job.position job.responsabilities job.tags
        ]


viewJobDuration : String -> String -> Element msg
viewJobDuration startedAt finishedAt =
    let
        colAttrs =
            [ height fill
            , width <| fillPortion 1
            , paddingXY 5 0
            , Border.widthEach { right = 2, top = 0, left = 0, bottom = 0 }
            , Border.color <| rgb255 220 220 220
            ]

        textAttrs =
            [ Font.size 12
            , Font.color <| rgb255 170 170 170
            ]    
    in
    column colAttrs
        [ row [ alignTop, alignRight ]
            [ el textAttrs <| text finishedAt ]
        , wrappedRow [ alignRight, alignRight ]
            [ el textAttrs <| text startedAt ]
        ]


viewJobDetails : String -> String -> List String -> List String -> Element msg
viewJobDetails client position responsabilities tags =
    let
        header =
            column [ spacingXY 10 5 ]
                [ row
                    [ Font.size 18
                    ]
                    [ text client ]
                , row
                    [ Font.size 14
                    , Font.color <| rgb255 128 128 128
                    ]
                    [ text position ]
                ] 

        chipsPanel =
            row [ spacingXY 5 10, paddingXY 0 10 ] <|
                List.map chip tags

        chip tag =
            el
                [ padding 3
                , Border.rounded 2
                , Background.color <| rgb255 230 230 230
                , Font.size 12
                ]
                (text tag)
            
        detail =
            column
                [ spacingXY 0 3
                , paddingEach { top = 5, left = 0, bottom = 0, right = 0}
                ] <|
                List.map
                    (\resp ->
                        paragraph
                            [ Font.size 12, Font.alignLeft ]
                            [ text <| "- " ++ resp ]
                    )
                    responsabilities
                

    in
    column [ paddingXY 10 0, width <| fillPortion 4 ]
        [ header
        , chipsPanel
        , detail
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


jobsDecoder : Decoder (List Job)
jobsDecoder =
    field "jobs"
        <| Json.Decode.list
        <| Json.Decode.map6 Job
            (field "started_at" string) 
            (field "finished_at" string)
            (field "tags" <| list string)
            (field "client" string)
            (field "position" string)
            (field "responsabilities" <| list string)

   