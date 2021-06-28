module Helpers where

import System.IO as I ( Handle )
import Add ( adder, appendToDo )
import Remove ( removeToDo, remover )
import View ( displayToDo )
import qualified Data.Map as M
import Maps ( commands, inputs )

helper :: [String] -> String -> I.Handle -> [String] -> [String] -> FilePath -> IO ()
helper args home handle contents numberedContents toDoPath
    | null args = do
                mapM_ putStrLn nullArgsInteract
                line <- getLine
                inpHandler line home handle contents numberedContents toDoPath
    | otherwise = auxHelper args home handle contents numberedContents toDoPath

inpHandler :: Foldable t => [Char] -> [Char] -> Handle -> [String] -> t String -> [Char] -> IO ()
inpHandler x home handle contents numberedContents toDoPath
    = maybeDoIO stuff fallback
    where stuff = M.lookup x $ inputs home handle contents numberedContents toDoPath
          fallback = putStrLn $ "Unknown Command: " ++ x ++ "\nQuitting."

auxHelper :: [String] -> [Char] -> I.Handle -> [String] -> [String] -> [Char] -> IO ()
auxHelper args home handle contents numberedContents toDoPath
    = maybeDoIO stuff fallback
    where header = head args
          stuff = M.lookup header $ commands args home handle contents numberedContents toDoPath
          fallback = mapM_ putStrLn $ auxErr header

maybeDoIO :: Maybe (IO ()) -> IO () -> IO ()
maybeDoIO (Just io) fallback = io
maybeDoIO Nothing fallback = fallback

auxErr :: [Char] -> [String]
auxErr x = ["Unknown command: " ++ x,
            "Known commands are: \n",
            "view",
            "add",
            "remove \n"]

nullArgsInteract :: [String]
nullArgsInteract = ["What would you like to do?",
                    "1. View your TODOs",
                    "2. Add a TODO",
                    "3. Remove a TODO"]
