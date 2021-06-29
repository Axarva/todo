module Remove (remover, removeToDo) where

import Data.List as L ( (\\), delete, intersect )
import Data.Maybe as A ( fromJust, isJust )
import System.Directory as D ( removeFile, renameFile )
import System.IO as I ( Handle, hClose, hPutStr, openTempFile )
import Data.Char as C ( isDigit )

remover :: [String] -> String -> I.Handle -> [String] -> [String]-> FilePath -> IO ()
remover args home handle contents numberedContents toDoPath
    | null args = removeToDo home handle contents numberedContents toDoPath
    | otherwise = do
        (tempName, tempHandle) <- I.openTempFile (home ++ "/.config/") "temp"
        let newToDo = checkPattern contents args
        I.hPutStr tempHandle (unlines newToDo)
        I.hClose handle
        I.hClose tempHandle
        D.removeFile toDoPath
        D.renameFile tempName toDoPath


indexremover :: [String] -> [Int] -> [String]
indexremover xs ys
    | null xs = []
    | null ys = xs
    | otherwise = indexremover (L.delete (xs !! head ys) xs) (drop 1 $ map (\x -> x - 1) ys)

removeToDo :: Foldable t => String -> I.Handle -> [String] -> t String -> FilePath -> IO ()
removeToDo home handle contents numberedContents toDoPath = do
    (tempName, tempHandle) <- I.openTempFile (home ++ "/.config/") "temp"
    putStrLn "Which of your TODOs would you like to remove? (Input indices only)"
    mapM_ putStrLn numberedContents
    num <- getLine
    let newToDo = checkPattern contents (words num)
    I.hPutStr tempHandle (unlines newToDo)
    I.hClose handle
    I.hClose tempHandle
    D.removeFile toDoPath
    D.renameFile tempName toDoPath

checkPattern :: [[Char]] -> [[Char]] -> [[Char]]
checkPattern contents args = newList
    where areDigits = filter (all C.isDigit) args
          notDigits = filter (not . all C.isDigit) args
          toBeRemoved = concatMap (\arg -> foldl (\acc content -> searchString content arg : acc) [] contents) notDigits
          newList = indexremover contents (map (\x -> (read x :: Int) - 1) areDigits) L.\\ filter (not . null) toBeRemoved

searchString :: [Char] -> [Char] -> [Char]
searchString content arg
    | null f = []
    | otherwise = content
    where f =  filter (\x -> x `elem` words content) (words arg)
