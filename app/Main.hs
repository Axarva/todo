module Main where

import qualified Control.Monad      as M
import qualified Data.List          as L
import qualified System.Directory   as D
import qualified System.Environment as E
import qualified System.IO          as I

import Add ( adder, appendToDo ) 
import Remove ( remover, removeToDo )
import View ( displayToDo )

main :: IO ()
main = do
    args <- E.getArgs
    home <- D.getHomeDirectory
    let toDoPath = if length args >= 2 && ".txt" `L.intersect` (args !! 1) == ".txt" then args !! 1 else home ++ "/.config/todo.txt"
    fileExist <- D.doesFileExist toDoPath
    M.unless fileExist $ I.writeFile toDoPath ""
    handle <- I.openFile toDoPath I.ReadMode
    contents <- lines <$> I.hGetContents handle
    let numberedContents = zipWith (\n line -> show n ++ " - " ++ line) [1..] contents
    helper args home handle contents numberedContents toDoPath
    I.hClose handle

helper :: [String] -> String -> I.Handle -> [String] -> [String] -> FilePath -> IO ()
helper args home handle contents numberedContents toDoPath
    | null args = do
                putStrLn "What would you like to do?"
                putStrLn "1. View your TODOs"
                putStrLn "2. Add a TODO"
                putStrLn "3. Remove a TODO"
                line <- getLine
                let inp = parser line
                case inp of
                    Just "1" -> displayToDo numberedContents
                    Just "2" -> appendToDo toDoPath handle
                    Just "3" -> removeToDo home handle contents numberedContents toDoPath
                    Just "q" -> putStrLn "Quitting."
    | otherwise = auxHelper args home handle contents numberedContents toDoPath

auxHelper :: [String] -> [Char] -> I.Handle -> [String] -> [String] -> [Char] -> IO ()
auxHelper args home handle contents numberedContents toDoPath
    | first == Just "view" =  displayToDo numberedContents
    | first == Just "add"  = if toDoPath == home ++ "/.config/todo.txt" then
                                     adder (drop 1 args) toDoPath handle
                                  else adder (drop 2 args) toDoPath handle
    | first == Just "remove" = if toDoPath == home ++ "/.config/todo.txt" then
                                        remover (drop 1 args) home handle contents numberedContents toDoPath
                                    else remover (drop 2 args) home handle contents numberedContents toDoPath
    | otherwise = return ()                                
    where first = head (Just <$> args)

parser :: String -> Maybe String
parser x
  | x `elem` ["1","2","3","q"] = Just x
  | otherwise = Nothing
