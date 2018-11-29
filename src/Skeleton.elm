module Skeleton exposing
    ( Details
    , Page(..)
    , view
    )


import Browser
import Html exposing (Html, div)
import Href
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input



type Page
    = Home
    | Blog
    | Post



-- NODE


type alias Details msg =
    { title : String
    , kids : List (Element msg)
    }



-- VIEW


view : Page -> (a -> msg) -> Details a -> Browser.Document msg
view page toMsg details =
    { title =
        details.title
    , body =
        [ layout [] <|
            column
                [ width fill
                , height fill
                ]
                [ viewHeader page
                , Element.map toMsg <| viewContent details.kids
                , viewFooter
                ]
        ]
    }



-- HEADER

viewHeader : Page -> Element msg
viewHeader page =
    let
        navLink path title active =
            let
                attrs =
                    if active then
                        [ centerX, centerY, Font.bold ]
                    else
                        [ centerX, centerY ]    
            in
            link attrs
                { url = path
                , label = Element.text title
                }
    in
    row
        [ width fill
        , height <| px 60
        , Background.color <| rgb255 250 250 250
        , spacingXY 10 0
        , Font.size 18
        ]
        [ navLink Href.toHome "Home" <| isActive page Home
        , navLink Href.toBlog "Blog" <| isActive page Blog
        ]



-- CONTENT

viewContent : List (Element msg) -> Element msg
viewContent kids =
    column [ height fill, width fill, padding 40 ]
        kids


-- FOOTER


viewFooter : Element msg
viewFooter =
    let
        linkRepo =
            link [ centerX, centerY ]
                { url = "https://github.com/haderman/my-site/"
                , label = Element.text "Check it out"
                }
    in
    row
        [ width fill
        , alignBottom
        , padding 5
        , Background.color <| rgb255 150 150 150
        ]
        [ paragraph
            [ centerX
            , Font.size 14
            ] 
            [ text "All code for this site is open source and written in Elm. "
            , linkRepo
            , text "! — © 2018-present Hader Cardona"
            ]
        ]
        


isActive : Page -> Page -> Bool
isActive page page_ =
    page == page_
