module Strings where

import Paths_todo_axarva (version)
import Data.Version (showVersion)

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


help :: [String]
help = ["todo-axarva " ++ showVersion version,
        "\nUsage: \n",
        "todo view (filename)                -- Shows the TODOs of the given filename,",
        "                                       or the default if no filename is given. \n",
        "todo add (filename) (TODO)          -- Adds the given TODO to the given file,",
        "                                       or default file if no filename is given. \n",
        "todo remove (filename) (index/TODO) -- Removes the given index OR TODO from the file,",
        "                                       or default file if no filename is given. Using",
        "                                       both in a single command is now supported. \n",
        "todo help                           -- Prints this message. \n",
        "todo version                        -- Prints out version.\n"
    ]

versionToDo :: String 
versionToDo = "todo-axarva " ++ showVersion version
