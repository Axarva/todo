module Helpers where

import System.IO as I ( Handle )
import Add ( adder, appendToDo )
import Remove ( removeToDo, remover )
import View ( displayToDo )

helper :: [String] -> String -> I.Handle -> [String] -> [String] -> FilePath -> IO ()
helper args home handle contents numberedContents toDoPath
    | null args = do
                putStrLn "What would you like to do?"
                putStrLn "1. View your TODOs"
                putStrLn "2. Add a TODO"
                putStrLn "3. Remove a TODO"
                line <- getLine
                let inp = parser line
                inpHandler inp home handle contents numberedContents toDoPath
    | otherwise = auxHelper args home handle contents numberedContents toDoPath

inpHandler :: Foldable t => Maybe [Char] -> String -> I.Handle -> [String] -> t String -> FilePath -> IO ()
inpHandler x home handle contents numberedContents toDoPath
    | x == Just "1" = displayToDo numberedContents
    | x == Just "2" = appendToDo toDoPath handle
    | x == Just "3" = removeToDo home handle contents numberedContents toDoPath
    | x == Just "q" = putStrLn "Quitting."
    | otherwise     = putStrLn "Command unrecognized"

auxHelper :: [String] -> [Char] -> I.Handle -> [String] -> [String] -> [Char] -> IO ()
auxHelper args home handle contents numberedContents toDoPath
    | first == Just "view" =  displayToDo numberedContents
    | first == Just "add"  = if toDoPath == home ++ "/.config/todo.txt" then
                                     adder (drop 1 args) toDoPath handle
                                  else adder (drop 2 args) toDoPath handle
    | first == Just "remove" = if toDoPath == home ++ "/.config/todo.txt" then
                                        remover (drop 1 args) home handle contents numberedContents toDoPath
                                    else remover (drop 2 args) home handle contents numberedContents toDoPath
    | otherwise = do
                    putStrLn $ "Unknown command: " ++ fromJustChar first
                    putStrLn "Known commands are: \n"
                    putStrLn "view"
                    putStrLn "add"
                    putStrLn "remove \n"
    where first = head (Just <$> args)

parser :: String -> Maybe String
parser x
  | x `elem` ["1","2","3","q"] = Just x
  | otherwise = Nothing

fromJustChar :: Maybe [Char] -> [Char]
fromJustChar (Just x) = x
fromJustChar Nothing  = ""
