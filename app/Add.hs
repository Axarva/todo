module Add (adder, appendToDo) where

import           Remove    (Container (..))
import           System.IO as I (Handle, hClose)

adder :: Container -> IO ()
adder container
    | null (args container) = appendToDo container
    | otherwise = do
        I.hClose (handle container)
        mapM_ (appendFile (toDoPath container) . (++ "\n")) (args container)

appendToDo :: Container -> IO ()
appendToDo container = do
        I.hClose (handle container)
        putStrLn "Write your new TODO here:"
        todoItem <- getLine
        appendFile (toDoPath container) (todoItem ++ "\n")
