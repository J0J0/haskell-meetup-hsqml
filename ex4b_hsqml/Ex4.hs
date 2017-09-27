module Main where
    
import qualified Data.Text as Text
import           Data.Text (Text)
import qualified Data.Text.IO as Text
    
import Graphics.QML

returnIO :: a -> IO a
returnIO = return

newContextObject :: [Member ()] -> IO AnyObjRef
newContextObject members = do
    c <- newClass members
    o <- newObject c ()
    return $ anyObjRef o

main :: IO ()
main = do
    let qmlfiledoc = fileDocument "ex4.qml"
        
    context <- newContextObject
        [ defMethod' "rotateText" $ \ _ txt -> returnIO (rot13 txt)
        , defMethod' "readTextFrom" $ \ _ path ->
            Text.readFile (Text.unpack path)
        , defMethod' "writeTextTo" $ \ _ txt path ->
            Text.writeFile (Text.unpack path) txt
        ]

    runEngineLoop defaultEngineConfig
        { initialDocument = qmlfiledoc
        , contextObject   = Just context
        }
    shutdownQt

-- pure man's ROT13
rot13 :: Text -> Text
rot13 = Text.map tr
    where
        tr :: Char -> Char
        tr 'a' = 'n'
        tr 'b' = 'o'
        tr 'c' = 'p'
        tr 'd' = 'q'
        tr 'e' = 'r'
        tr 'f' = 's'
        tr 'g' = 't'
        tr 'h' = 'u'
        tr 'i' = 'v'
        tr 'j' = 'w'
        tr 'k' = 'x'
        tr 'l' = 'y'
        tr 'm' = 'z'
        tr 'n' = 'a'
        tr 'o' = 'b'
        tr 'p' = 'c'
        tr 'q' = 'd'
        tr 'r' = 'e'
        tr 's' = 'f'
        tr 't' = 'g'
        tr 'u' = 'h'
        tr 'v' = 'i'
        tr 'w' = 'j'
        tr 'x' = 'k'
        tr 'y' = 'l'
        tr 'z' = 'm'
        tr 'A' = 'N'
        tr 'B' = 'O'
        tr 'C' = 'P'
        tr 'D' = 'Q'
        tr 'E' = 'R'
        tr 'F' = 'S'
        tr 'G' = 'T'
        tr 'H' = 'U'
        tr 'I' = 'V'
        tr 'J' = 'W'
        tr 'K' = 'X'
        tr 'L' = 'Y'
        tr 'M' = 'Z'
        tr 'N' = 'A'
        tr 'O' = 'B'
        tr 'P' = 'C'
        tr 'Q' = 'D'
        tr 'R' = 'E'
        tr 'S' = 'F'
        tr 'T' = 'G'
        tr 'U' = 'H'
        tr 'V' = 'I'
        tr 'W' = 'J'
        tr 'X' = 'K'
        tr 'Y' = 'L'
        tr 'Z' = 'M'
        tr  c  = c
