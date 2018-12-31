module World.Forest exposing
  ( Model
  , init
  , Msg
  , update
  , view
  , subscriptions
  )


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Animation exposing (px, em, percent)
import Animation.Messenger



-- MODEL


type alias Model =
    { style : Animation.Messenger.State Msg
    , background : Animation.Messenger.State Msg
    , tag : String
    }


initModel : Model
initModel =
    { style =
        Animation.style
            [ Animation.opacity 1.0
            , Animation.translate (px 0) (px 0)
            ]
    , background =
        Animation.style
            [ Animation.backgroundColor { red = 0, green = 0, blue = 0, alpha = 1.0 }
            ]
    , tag = "hola perros forest"
    }


initAnimation : Model -> Model
initAnimation model =
    { model
        | background =
            Animation.interrupt
                [ Animation.to
                    [ Animation.backgroundColor { red = 0, green = 180, blue = 255, alpha = 1.0 }
                    ]
                ]
                model.background
    }


init : ( Model, Cmd Msg )
init =
    ( initAnimation initModel, Cmd.none )

 

-- UPDATE


type Msg
    = Animate Animation.Msg
    | OnClick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate animMsg ->
            let
                background =
                    Animation.update animMsg model.background

            in
            ( { model
                | background = background
              }
            , Cmd.none
            )
    
        OnClick ->
            ( { model
                | tag = "CHAO"
                , style =
                    Animation.interrupt
                        [ Animation.to
                            [ Animation.translate (px 0) (px 400) ]
                        ]
                        model.style
            },
            Cmd.none
            )



subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate [ model.background ]
        ]
  


-- VIEW


view : Model -> Html Msg
view model =
    let
        clouds =
            div [ Html.Attributes.class "background" ]
                [ div [ Html.Attributes.class "x1" ]
                    [ div [ Html.Attributes.class "cloud" ] []
                    ]
                , div [ Html.Attributes.class "x2" ]
                    [ div [ Html.Attributes.class "cloud" ] []
                    ]
                , div [ Html.Attributes.class "x3" ]
                    [ div [ Html.Attributes.class "cloud" ] []
                    ]
                , div [ Html.Attributes.class "x4" ]
                    [ div [ Html.Attributes.class "cloud" ] []
                    ]
                , div [ Html.Attributes.class "x5" ]
                    [ div [ Html.Attributes.class "cloud" ] []
                    ]
                ]

    in
    div ( Animation.render model.background
            ++ [ class "fill" ]
        )
        [ clouds
        , div
            (Animation.render model.style
                ++ [ Html.Attributes.class "forest-ground"
                    , onClick OnClick
                    ]
            )
            []
        , div [] [ text model.tag ]
        ]

