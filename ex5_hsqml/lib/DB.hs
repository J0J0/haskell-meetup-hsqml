{-# LANGUAGE TypeOperators, OverloadedStrings, DeriveGeneric #-}

module DB (
      Category(..)
    , Recipe(..)
    , getCategoriesIO
    , getRecipesIO
) where
    
import GHC.Generics (Generic)
import Database.Selda
import Database.Selda.Generic
import Database.Selda.SQLite

import Paths_ex5

getDBPath :: IO FilePath
getDBPath = getDataFileName "data/test.db"


cats :: Table (Int :*: Text :*: Int)
cats = table "categories" $ primary "id" :*: required "name" :*: required "parent_id"
catsId :*: catsName :*: _ = selectors cats

catList :: Table (Int :*: Int)
catList = table "category_list" $ required "recipe_id" :*: required "category_id"
catListRecId :*: catListCatId = selectors catList

recipes :: Table (Int :*: Maybe Text)
recipes = table "recipes" $ required "id" :*: optional "title"
recipesId :*: recipesTitle = selectors recipes


data Category = Category 
    { catId     :: Int
    , catName   :: Text
    , catParent :: Int
    } deriving (Show, Generic)

data Recipe = Recipe 
    { recipeId    :: Int
    , recipeTitle :: Maybe Text
    } deriving (Show, Generic)

getCategories :: MonadSelda m => m [Category]
getCategories = fromRels <$> (query $ select cats)

getRecipes :: MonadSelda m => [Category] -> m [Recipe]
getRecipes cs = do
    let cis = fmap (int . catId) cs
    rs <- query $ do 
        r <- select recipes
        restrict $ (r ! recipesId) `isIn` do
            cl_r_id :*: cl_cat_id <- select catList
            restrict $ cl_cat_id `isIn` cis
            return cl_r_id
        return r
    return $ fromRels rs


withDB :: SeldaM a -> IO a
withDB run = do 
    dbPath <- getDBPath
    withSQLite dbPath run

getCategoriesIO :: IO [Category]
getCategoriesIO = withDB getCategories

getRecipesIO :: [Category] -> IO [Recipe]
getRecipesIO cs = withDB (getRecipes cs)
