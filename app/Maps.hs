module Maps where

import qualified Data.Map as M
import System.IO as I ( Handle )

import Add ( adder, appendToDo )
import Remove ( removeToDo, remover )
import View ( displayToDo )
import Strings (help, versionToDo)

commands :: [String] -> [Char] -> I.Handle -> [String] -> [String] -> [Char] -> M.Map [Char] (IO ())
commands args home handle contents numberedContents toDoPath
         = M.fromList [("view", displayToDo numberedContents),
                       ("add", if toDoPath == home ++ "/.config/todo.txt" then
                                     adder (drop 1 args) toDoPath handle
                               else adder (drop 2 args) toDoPath handle),
                        ("remove", if toDoPath == home ++ "/.config/todo.txt" then
                                        remover (drop 1 args) home handle contents numberedContents toDoPath
                                   else remover (drop 2 args) home handle contents numberedContents toDoPath),
                        ("help", mapM_ putStrLn help),
                        ("version", putStrLn versionToDo)
                      ]

inputs :: Foldable t => String -> I.Handle -> [String] -> t String -> FilePath -> M.Map [Char] (IO ())
inputs home handle contents numberedContents toDoPath
        = M.fromList [("1", displayToDo numberedContents),
                     ("2", appendToDo toDoPath handle),
                     ("3", removeToDo home handle contents numberedContents toDoPath),
                     ("q", putStrLn "Quitting.")
                    ]
