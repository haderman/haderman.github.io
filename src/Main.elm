import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Home as Home
import Page.Blog as Blog
import Page.Post as Post
import Url
import Url.Parser as Parser exposing (Parser, (</>), custom, map, oneOf, s, top)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound
    | Home Home.Model
    | Blog Blog.Model
    | Post Post.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
  stepUrl url
    { key = key
    , page = NotFound
    }



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Home.Msg
    | BlogMsg Blog.Msg
    | PostMsg Post.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            stepUrl url model

        _ ->
            ( model, Cmd.none )


stepHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
stepHome model (home, cmds) =
    ( { model | page = Home home }
    , Cmd.map HomeMsg cmds
    )


stepBlog : Model -> ( Blog.Model, Cmd Blog.Msg ) -> ( Model, Cmd Msg )
stepBlog model (blog, cmds) =
    ( { model | page = Blog blog }
    , Cmd.map BlogMsg cmds
    )


stepPost : Model -> ( Post.Model, Cmd Post.Msg ) -> ( Model, Cmd Msg )
stepPost model (post, cmds) =
    ( { model | page = Post post }
    , Cmd.map PostMsg cmds
    )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            { title = "Not found"
            , body =
                [ text "Not Found" ]
            }

        Home home ->
            { title = "Home"
            , body =
                [ Html.map HomeMsg (Home.view home) ]
            }

        Blog blog ->
            { title = "Blog"
            , body =
                [ Html.map BlogMsg (Blog.view blog) ]
            }

        Post post ->
            { title = "Post"
            , body =
                [ Html.map PostMsg (Post.view post) ]
            }



-- ROUTER


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        parser =
            oneOf
                [ route top
                    ( stepHome model (Home.init "Home")
                    )
                , route (s "blog" )
                    ( stepBlog model (Blog.init "Blog")
                    )
                , route (s "blog" </> post_)
                    (\post ->
                        stepPost model (Post.init post "Post")
                    )
                ]

    in
    case Parser.parse parser url of
        Just answer ->
            answer
    
        Nothing ->
            ( model, Cmd.none )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser


post_ : Parser (String -> a) a
post_ =
    custom "POST" Just

