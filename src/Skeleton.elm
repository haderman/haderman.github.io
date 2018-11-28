module Skeleton exposing
    ( Details
    , view
    )


import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Href



-- NODE


type alias Details msg =
    { title : String
    , kids : List (Html msg)
    }



-- VIEW


view : (a -> msg) -> Details a -> Browser.Document msg
view toMsg details =
    { title =
        details.title
    , body =
        [ viewHeader
        , Html.map toMsg <|
            div (class "center" :: []) details.kids
        , viewFooter
        ]
    }



-- HEADER

viewHeader : Html msg
viewHeader =
    div [ class "header" ]
        [ nav []
            [ viewLink Href.toHome "Home"
            , viewLink Href.toBlog "Blog"
            ]
        ]


viewLink : String -> String -> Html msg
viewLink path title =
    a [ href path ] [ text title ]



-- FOOTER


viewFooter : Html msg
viewFooter =
  div [class "footer"]
    [ text "All code for this site is open source and written in Elm. "
    , a [ class "grey-link", href "https://github.com/haderman/my-site/" ] [ text "Check it out" ]
    , text "! — © 2018-present Hader Cardona"
    ]
