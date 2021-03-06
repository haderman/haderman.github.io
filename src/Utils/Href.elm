module Utils.Href exposing
  ( toHome
  , toBlog
  , toPost
  , toTwitter
  , toGithub
  , toAbout
  , toCodepen
  )


import Url.Builder as Url



-- HREFS


toHome : String
toHome =
    Url.absolute [] []


toBlog : String
toBlog =
    Url.absolute [ "blog" ] []


toAbout : String
toAbout =
    Url.absolute [ "about" ] []


toPost : Int -> String
toPost post_ =
    Url.absolute [ "blog", String.fromInt post_ ] []


toGithub : String
toGithub =
    "https://github.com/haderman"


toTwitter : String
toTwitter =
    "https://twitter.com/haderman7"


toCodepen : String
toCodepen =
    "https://codepen.io/haderman"