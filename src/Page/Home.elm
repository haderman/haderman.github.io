module Page.Home exposing
  ( Model
  , init
  , Msg
  , update
  , view
  , subscriptions
  )


import Time exposing (millisToPosix)
import Animation exposing (px, em, percent)
import Animation.Messenger
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Element exposing (Element, html)
import Svg exposing (svg, rect, circle, path, polygon)
import Svg.Attributes exposing (..)
import Json.Decode as Decode exposing (Decoder, Value, map2, fail, field, float)


-- PROJECT IMPORTS

import Skeleton
import Utils.Href exposing (toAbout)
import World.Forest as Forest
import World.Desert as Desert



-- MODEL


type alias Screen =
    { width : Float  
    , height : Float
    }


type alias Model =
    { title : String
    , style : Animation.Messenger.State Msg
    , screen : Screen
    , background : Animation.State
    , world : World 
    }


type World
    = Universe
    | Forest Forest.Model
    | Desert Desert.Model


type Planet
    = ForestPlanet
    | DesertPlanet


initModel : String -> Screen -> Model
initModel title screen =
    { title = title
    , world = Universe
    , style =
        Animation.style
            [ Animation.opacity 1.0
            , Animation.translate (px 0) (px 0)
            ]
    , screen = screen
    , background =
        Animation.style
            [ Animation.backgroundColor { red = 0, green = 0, blue = 0, alpha = 1.0 }
            ]
    }


init : Decode.Value -> String -> ( Model, Cmd Msg )
init value title =
    let
        screen =
            case Decode.decodeValue screenDecoder value of
                Ok screen_  ->
                    screen_
            
                Err err ->
                    Screen 800 800

    in
    ( initModel title screen
    , Cmd.none
    )



-- UPDATE


type Msg
    = OnClick Planet
    | ForestMsg Forest.Msg
    | DesertMsg Desert.Msg
    | Animate Animation.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        OnClick planet ->
            let
                ( newModel, cmd ) =
                    case planet of
                        ForestPlanet -> stepForest model (Forest.init)  
                        DesertPlanet -> stepDesert model (Desert.init)  
                        
            in
            ({ newModel
                | background =
                    Animation.interrupt
                        [ Animation.to
                            [ backgroundColor newModel.world ]
                        ]
                        model.background
            }
            , cmd
            )

        Animate animMsg ->
            let
                ( newStyle, cmd ) =
                    Animation.Messenger.update animMsg model.style

                newBackground =
                    Animation.update animMsg model.background
            in
            ( { model
                | style = newStyle
                , background = newBackground
              }
            , cmd
            )

        ForestMsg msg ->
            case model.world of
                Forest forest -> stepForest model (Forest.update msg forest) 
                _             -> ( model, Cmd.none )
                
        DesertMsg msg ->
            case model.world of
                Desert desert -> stepDesert model (Desert.update msg desert) 
                _             -> ( model, Cmd.none )


stepForest : Model -> ( Forest.Model, Cmd Forest.Msg ) -> ( Model, Cmd Msg)
stepForest model (forest, cmds) =
    ( { model | world = Forest forest }
    , Cmd.map ForestMsg cmds
    )


stepDesert : Model -> ( Desert.Model, Cmd Desert.Msg ) -> ( Model, Cmd Msg)
stepDesert model (desert, cmds) =
    ( { model | world = Desert desert }
    , Cmd.map DesertMsg cmds
    )


backgroundColor : World -> Animation.Property
backgroundColor world =
    case world of
        Forest _ ->
            Animation.backgroundColor { red = 0, green = 180, blue = 255, alpha = 1.0 }
        
        Desert _ ->
            Animation.backgroundColor { red = 246, green = 185, blue = 59, alpha = 1.0 }

        Universe ->
            Animation.backgroundColor { red = 0, green = 0, blue = 0, alpha = 1.0 }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.world of
        Universe ->
            Sub.batch
                [ Animation.subscription Animate [ model.style ]
                , Animation.subscription Animate [ model.background ]
                ]
    
        Forest forest ->
            Sub.map ForestMsg (Forest.subscriptions forest)

        Desert desert ->
            Sub.map DesertMsg (Desert.subscriptions desert)



-- VIEW


view : Model -> Skeleton.Details Msg
view model =
    { title = model.title
    , kids = [ Element.html <| viewContent model ]
    }


viewContent : Model -> Html Msg
viewContent model =
    case model.world of
        Universe ->
            viewUniverse model
    
        Forest forestModel ->
            Html.map ForestMsg <| Forest.view forestModel

        Desert desertModel ->
            Html.map DesertMsg <| Desert.view desertModel
                


viewUniverse : Model -> Html Msg
viewUniverse model =
    let
        stars =
            div [ Html.Attributes.class "absolute" ]
                [ div [ Html.Attributes.class "stars small" ] []
                , div [ Html.Attributes.class "stars medium" ] []
                , div [ Html.Attributes.class "stars large" ] []
                ]
        
        planets =
            div [ Html.Attributes.class "planets-container" ]
                [ viewForestPlanet
                , viewDesertPlanet
                ]

    in
        div
            (Animation.render model.background
                ++ [ Html.Attributes.class "sky" ]
            )
            [ stars, planets ]


viewForestPlanet : Html Msg
viewForestPlanet =
    div
        [ onClick (OnClick ForestPlanet)
        , Html.Attributes.class "planet forest-planet"
        , Html.Attributes.style "top" "30px"
        , Html.Attributes.style "left" "30px"
        ]
        [ svg
            [ viewBox "0 0 250 250"
            ]
            [ circle
                [ cx "121"
                , cy "121"
                , r "109"
                ] []
            , polygon
                [ points "38 105 42 110 41 120 44 126 48 126 56 129 59 136 64 136 69 133 72 134 74 139 80 147 86 146 94 138 97 132 106 135 116 135 125 132 141 132 149 136 159 136 159 124 150 117 138 102 138 92 147 84 141 76 131 75 120 72 103 71 89 63 75 66 80 73 88 73 86 79 74 91 60 96 62 91 53 89 41 92 35 97"
                ] []
            , polygon
                [ points "142 159 132 165 132 172 127 172 125 176 129 182 135 182 138 179 146 181 150 181 153 190 161 192 166 191 166 186 162 187 157 187 157 180 159 174 155 167 152 160 143 154 136 154 140 160"
                ] []
            , polygon
                [ points "221 164 226 153 229 139 230 131 231 120 230 104 224 88 219 88 215 89 211 97 217 97 219 91 221 97 223 104 219 106 204 111 204 128 211 134 214 133 214 128 211 123 213 115 223 118 225 132 220 139 218 146 215 154 204 155 196 162 197 176 209 173 216 169"
                ] []
            , polygon
                [ points "99 15 113 12 122 12 139 13 150 16 160 19 172 24 190 35 207 52 199 52 191 60 181 59 171 55 171 52 177 53 177 49 172 40 160 41 149 41 145 46 124 45 112 49 98 46 94 53 90 52 90 44 97 38 111 36 121 37 127 32 134 29 125 19 103 19 88 25 74 30 64 36 60 57 51 61 39 58 31 67 27 64 37 49 53 34 75 21 96 14"
                ] []
            , polygon
                [ points "33 188 45 190 53 185 55 175 61 168 68 168 81 165 78 175 73 177 73 185 74 203 70 207 72 214 72 218 59 212 44 201"
                ] []
            ]
        ]


viewDesertPlanet : Html Msg
viewDesertPlanet =
    div
        [ onClick (OnClick DesertPlanet)
        , Html.Attributes.class "planet desert-planet"
        , Html.Attributes.style "top" "260px"
        , Html.Attributes.style "left" "160px"
        ]
        [ svg
            [ viewBox "0 0 250 250"
            ]
            [ circle
                [ cx "121"
                , cy "121"
                , r "109"
                ] []
            , polygon
                [ points "30.5725 60.5344 40.4962 52.5954 47.4427 54.5802 51.4122 51.6031 57.3664 42.6718 66.2977 37.7099 75.229 37.7099 78.2061 31.7557 87.1374 30.7634 101.031 35.7252 110.954 35.7252 109.962 52.5954 105 59.542 98.0534 61.5267 85.1527 74.4275 82.1756 79.3893 77.2137 93.2824 62.3282 96.2595 58.3588 90.3053 49.4275 95.2672 31.5649 95.2672 28.5878 103.206 21.6412 112.137 11.7176 113.13 13.7023 93.2824 22.6336 74.4275 26.6031 67.4809"
                ] []
            , polygon
                [ points "166.527 21.8321 164.542 30.7634 165.534 41.6794 164.542 53.5878 161.565 58.5496 158.588 65.4962 155.611 72.4427 151.641 77.4046 147.672 83.3588 146.679 90.3053 140.725 98.2443 135.763 111.145 124.847 112.137 121.87 116.107 110.954 120.076 101.031 119.084 95.0763 128.015 95.0763 133.969 95.0763 142.901 100.038 147.863 107.977 156.794 111.947 162.748 122.863 161.756 136.756 161.756 151.641 151.832 161.565 145.878 167.519 136.947 173.473 126.031 182.405 120.076 189.351 121.069 191.336 117.099 196.298 104.198 202.252 92.2901 205.229 80.3817 215.153 79.3893 214.16 70.458 210.191 61.5267 210.191 56.5649 198.282 42.6718 181.412 28.7786 167.519 20.8397"
                ] []
            , polygon
                [ points "46.4504 202.443 65.3053 207.405 72.2519 211.374 76.2214 212.366 78.2061 209.389 87.1374 209.389 91.1069 211.374 98.0534 211.374 100.038 206.412 105.992 205.42 112.939 205.42 119.885 201.45 134.771 202.443 148.664 202.443 154.618 196.489 168.511 185.573 180.42 178.626 188.359 165.725 193.321 160.763 201.26 161.756 203.244 170.687 199.275 183.588 188.359 188.55 183.397 198.473 172.481 198.473 169.504 204.427 164.542 209.389 158.588 213.359 149.656 219.313 135.763 219.313 129.809 225.267 123.855 229.237 112.939 230.229 95.0763 228.244 77.2137 222.29 61.3359 213.359"
                ] []
            ]
        ]



-- DECODERS


screenDecoder : Decoder Screen
screenDecoder =
    field "screen" <|
        Decode.map2 Screen
            (field "width" float)
            (field "height" float)