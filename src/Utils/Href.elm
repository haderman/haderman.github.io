module Utils.Href exposing
  ( toHome
  , toBlog
  , toPost
  )


import Url.Builder as Url



-- HREFS


toHome : String
toHome =
    Url.absolute [] []


toBlog : String
toBlog =
    Url.absolute [ "blog" ] []


toPost : Int -> String
toPost post_ =
    Url.absolute [ "blog", String.fromInt post_ ] []
