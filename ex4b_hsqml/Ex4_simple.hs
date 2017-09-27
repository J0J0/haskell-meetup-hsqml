{-# LANGUAGE NoImplicitPrelude #-}

module Main where
    
import Graphics.QML

main = do
    let qmlfiledoc = fileDocument "ex4.qml"
    runEngineLoop defaultEngineConfig {
        initialDocument = qmlfiledoc
        }
    shutdownQt
