module Maps where

import Paths_todo_axarva (version)
import Data.Version (showVersion)
import qualified Data.Map as M
import System.IO as I ( Handle )

import Add ( adder, appendToDo )
import Remove ( removeToDo, remover )
import View ( displayToDo )

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
                        ("version", putStrLn $ "todo-axarva " ++ showVersion version)
                      ]

inputs :: Foldable t => String -> I.Handle -> [String] -> t String -> FilePath -> M.Map [Char] (IO ())
inputs home handle contents numberedContents toDoPath
        = M.fromList [("1", displayToDo numberedContents),
                     ("2", appendToDo toDoPath handle),
                     ("3", removeToDo home handle contents numberedContents toDoPath),
                     ("q", putStrLn "Quitting.")
                    ]

help :: [String]
help = ["todo-axarva " ++ showVersion version,
        "\nUsage: \n",
        "todo view (filename)                -- Shows the TODOs of the given filename,",
        "                                       or the default if no filename is given. \n",
        "todo add (filename) (TODO)          -- Adds the given TODO to the given file,",
        "                                       or default file if no filename is given. \n",
        "todo remove (filename) (index/TODO) -- Removes the given index OR TODO from the file,",
        "                                       or default file if no filename is given. Either",
        "                                       index or TODO can be used in a single command.",
        "                                       Using both is not supported. \n",
        "todo help                           -- Prints this message. \n",
        "todo version                        -- Prints out version.\n"
    ]
