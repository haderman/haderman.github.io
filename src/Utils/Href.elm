module Utils.Href exposing
  ( toHome
  , toBlog
  , toPost
  , toTwitter
  , toGithub
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


toGithub : String
toGithub =
    "https://github.com/haderman"


toTwitter : String
toTwitter =
    "https://twitter.com/haderman7"