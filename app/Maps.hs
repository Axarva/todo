module Maps where

import qualified Data.Map as M
import System.IO as I ( Handle )

import Add ( adder, appendToDo )
import Remove ( removeToDo, remover, Container(..) )
import View ( displayToDo )
import Strings (help, versionToDo)


commands :: Container -> M.Map [Char] (IO ())
commands container@Container {args = args,
                  home = home,
                  handle = handle,
                  contents = contents,
                  numberedContents = numberedContents,
                  toDoPath = toDoPath}
         = M.fromList [("view", displayToDo container),
                       ("add", if toDoPath == home ++ "/.config/todo.txt" then
                                     adder oneDropContainer
                               else adder twoDropContainer),
                        ("remove", if toDoPath == home ++ "/.config/todo.txt" then
                                        remover oneDropContainer
                                   else remover twoDropContainer),
                        ("help", mapM_ putStrLn help),
                        ("version", putStrLn versionToDo)
                      ]
         where oneDropContainer = Container (drop 1 args) home handle contents numberedContents toDoPath
               twoDropContainer = Container (drop 2 args) home handle contents numberedContents toDoPath


inputs :: Container -> M.Map [Char] (IO ())
inputs container
        = M.fromList [("1", displayToDo container),
                     ("2", appendToDo container),
                     ("3", removeToDo container),
                     ("q", putStrLn "Quitting.")
                    ]
