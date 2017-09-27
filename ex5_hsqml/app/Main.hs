{-# LANGUAGE OverloadedStrings, TypeFamilies, UndecidableInstances #-}

module Main where

-- From packages:
import           Data.IORef (IORef, newIORef, readIORef, writeIORef)
import           Data.Maybe (fromMaybe)
import qualified Data.Text as T
import qualified Data.Vector as V
import           Data.Vector (Vector)
import           Graphics.QML  -- this is from HsQML

-- (see https://www.haskell.org/cabal/users-guide/developing-packages.html#accessing-data-files-from-package-code)
import Paths_ex5

-- Database interface:
import qualified DB
import           DB (Category(catName), Recipe(recipeTitle))


-- This allows HsQML to retrieve a JS array as Vector and to pass
-- Vector values to QML in the converse direction.
--
instance (Marshal a, CanGetFrom a ~ Yes, CanPassTo a ~ Yes)
    => Marshal (Vector a) where
    type MarshalMode (Vector a) c d = MarshalMode [a] c d
    marshaller = bidiMarshaller V.fromList V.toList


-- Just some helper functions that make the allocation of
-- the context object easier.

newContextObject :: [Member ()] -> IO AnyObjRef
newContextObject members = do
    c <- newClass members
    o <- newObject c ()
    return $ anyObjRef o

fromIORef :: IORef a -> ObjRef obj -> IO a
fromIORef ref = fromIORefWith ref id

fromIORefWith :: IORef a -> (a -> b) -> ObjRef obj -> IO b
fromIORefWith ref f = const $ fmap f (readIORef ref)

newSignalKeyNoArgs :: IO (SignalKey (IO ()))
newSignalKeyNoArgs = newSignalKey

--
    
main :: IO ()
main = do
    cats_p <- newIORef $ (V.empty :: Vector Category)
    recs_p <- newIORef $ ([] :: [T.Text])
    
    sigCategories <- newSignalKeyNoArgs
    sigRecipes    <- newSignalKeyNoArgs
    
    -- this will be the link to the QML engine
    context <- newContextObject [
        -- read-only property with associated signal
        defPropertySigRO' "categoriesList" sigCategories $
            fromIORefWith cats_p (fmap catName)
        ,
        -- method without "real arguments" (only the "self pointer")
        defMethod' "updateCategories" $ \ obj -> do
            cs <- DB.getCategoriesIO
            writeIORef cats_p $ V.fromList cs
            fireSignal sigCategories obj
            -- the last line informs the QML engine that the property
            -- associated to this signal was changed (and thus triggers
            -- reevaluation of all bindings that reference the property).
        ,
        -- read-only property with associated signal
        defPropertySigRO' "recipesList" sigRecipes $ fromIORef recs_p
        ,
        -- method with one real argument:
        -- it retrieves indices of selected items (as [Int])
        defMethod' "updateRecipes" $ \ obj sel -> do
            cs <- readIORef cats_p
            rs <- DB.getRecipesIO $ fmap (cs V.!) sel
            writeIORef recs_p $ fmap (fromMaybe "[empty title]" . recipeTitle) rs
            fireSignal sigRecipes obj
        ]
    
    qmlMainFile <- getDataFileName "qml/main.qml"
    runEngineLoop defaultEngineConfig {
        initialDocument = fileDocument qmlMainFile,
        contextObject   = Just context
        }
    shutdownQt
