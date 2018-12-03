module Skeleton exposing
    ( Details
    , Page(..)
    , view
    )


import Browser
import Html exposing (Html, div)
import Utils.Href as Href
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
        [ layout [ Font.color (rgb255 65 74 76) ] <|
            column
                [ width fill
                , height fill
                ]
                [ Element.map toMsg <| viewContent details.kids
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
        , Border.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
        , Border.color <| rgb255 234 234 234
        , spacingXY 10 0
        , Font.size 18
        ]
        [ navLink Href.toHome "Home" <| isActive page Home
        , navLink Href.toBlog "Blog" <| isActive page Blog
        ]



-- CONTENT

viewContent : List (Element msg) -> Element msg
viewContent kids =
    column [ height fill, width fill, padding 10 ]
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
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color <| rgb255 234 234 234
        ]
        [ paragraph
            [ centerX
            , Font.size 14
            ] 
            [ text "All code for this site is open source and with ♥. "
            , linkRepo
            , text "! — © 2018-present Hader Cardona"
            ]
        ]
        


isActive : Page -> Page -> Bool
isActive page page_ =
    page == page_
