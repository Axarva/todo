module Remove (remover, removeToDo) where

import Data.List as L ( (\\), delete, intersect )
import Data.Maybe as A ( fromJust )
import System.Directory as D ( removeFile, renameFile )
import System.IO as I ( Handle, hClose, hPutStr, openTempFile )
import Text.Read as R ( readMaybe )


remover :: [String] -> String -> I.Handle -> [String] -> [String]-> FilePath -> IO ()
remover args home handle contents numberedContents toDoPath
    | null args = removeToDo home handle contents numberedContents toDoPath
    | notElem Nothing (map readToInt args) && A.fromJust (maximum (map readToInt args)) < length contents = error "Very large index!"
    | otherwise = do
        (tempName, tempHandle) <- I.openTempFile (home ++ "/.config/") "temp"
        let newToDo = if Nothing `elem` map readToInt args then
                        (L.\\) contents (concatMap (\arg -> filter (\toDo -> arg `L.intersect` toDo == arg) contents) args)
                      else indexremover contents (map (\x -> (read x :: Int) - 1) args)
        I.hPutStr tempHandle (unlines newToDo)
        I.hClose handle
        I.hClose tempHandle
        D.removeFile toDoPath
        D.renameFile tempName toDoPath


indexremover :: [String] -> [Int] -> [String]
indexremover xs ys
    | null xs = []
    | null ys = xs
    | otherwise = indexremover (L.delete (xs !! head ys) xs) (drop 1 ys)

removeToDo :: Foldable t => String -> I.Handle -> [String] -> t String -> FilePath -> IO ()
removeToDo home handle contents numberedContents toDoPath = do
    (tempName, tempHandle) <- I.openTempFile (home ++ "/.config/") "temp"
    putStrLn "Which of your TODOs would you like to remove?"
    mapM_ putStrLn numberedContents
    num <- getLine
    let readNum = read num :: Int
        newToDo = L.delete (contents !! (readNum - 1)) contents
    I.hPutStr tempHandle (unlines newToDo)
    I.hClose handle
    I.hClose tempHandle
    D.removeFile toDoPath
    D.renameFile tempName toDoPath

readToInt :: String -> Maybe Int
readToInt = R.readMaybe
