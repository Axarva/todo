module Add (adder, appendToDo) where

import System.IO as I ( Handle, hClose )

adder :: Foldable t => t String -> FilePath -> I.Handle -> IO ()
adder args toDoPath handle
    | null args = appendToDo toDoPath handle
    | otherwise = do
        I.hClose handle
        mapM_ (appendFile toDoPath . (++ "\n")) args

appendToDo :: FilePath -> I.Handle -> IO ()
appendToDo toDoPath handle = do
        I.hClose handle
        putStrLn "Write your new TODO here:"
        todoItem <- getLine
        appendFile toDoPath (todoItem ++ "\n")
