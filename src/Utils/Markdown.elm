module Utils.Markdown exposing (block)

import Html
import Markdown exposing (defaultOptions)
import Html.Attributes exposing (class)


block : String -> Html.Html msg
block raw =
  Markdown.toHtmlWith myOptions [ class "markdown" ] raw


myOptions : Markdown.Options
myOptions =
  { defaultOptions | defaultHighlighting = Just "elm" }