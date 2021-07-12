module Main where

import qualified Control.Monad      as M
import qualified Data.List          as L
import qualified System.Directory   as D
import qualified System.Environment as E
import qualified System.IO          as I

import           Helpers            (helper)
import           Remove             (Container (Container))

main :: IO ()
main = do
    args <- E.getArgs
    home <- D.getHomeDirectory
    let toDoPath = if length args >= 2 && ".txt" `L.intersect` (args !! 1) == ".txt" then
                     args !! 1
                   else home ++ "/.config/todo.txt"
    fileExist <- D.doesFileExist toDoPath
    M.unless fileExist $ I.writeFile toDoPath ""
    handle <- I.openFile toDoPath I.ReadMode
    contents <- lines <$> I.hGetContents handle
    let numberedContents = zipWith (\n line -> show n ++ " - " ++ line) [1..] contents
        container = Container args home handle contents numberedContents toDoPath
    helper container
    I.hClose handle
