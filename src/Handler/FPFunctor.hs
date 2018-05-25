{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.FPFunctor where

import Import
import Yesod.Markdown
import Text.Pandoc
import Text.Pandoc.Writers.Math (defaultMathJaxURL)

myExtensions :: Extensions
myExtensions = githubMarkdownExtensions `mappend`
  extensionsFromList (yesodDefaultExtensions <> [Ext_tex_math_dollars, Ext_tex_math_double_backslash, Ext_tex_math_single_backslash])

myWriterOptions :: WriterOptions
myWriterOptions = yesodDefaultWriterOptions
  { writerHTMLMathMethod = MathJax defaultMathJaxURL
  , writerExtensions = myExtensions
  }

myReaderOptions :: ReaderOptions
myReaderOptions = yesodDefaultReaderOptions
  { readerExtensions = myExtensions
  }

myMarkdownToHtml :: Markdown -> Either PandocError Html
myMarkdownToHtml = markdownToHtmlWith myReaderOptions myWriterOptions

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getFPFunctorR :: Handler Html
getFPFunctorR = do
  Right content <- liftIO
    $ fmap myMarkdownToHtml
    $ markdownFromFile "templates/functor.md"

  defaultLayout $ do
    setTitle "Functor (fp typeclass)"
    toWidgetHead
      [hamlet|
        <script type="text/x-mathjax-config">
          MathJax.Hub.Config({ tex2jax: { inlineMath: [['$','$'], ["\\(","\\)"]] } });
        <script type="text/javascript"
          src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML">
      |]
    [whamlet|
      <div class="content">
        #{content}
    |]
  {-
  defaultLayout $ do
      setTitle "Functor (fp typeclass)"
      $(widgetFile "functor")
  -}
