module Remove where

import           Control.Monad    as M (when)
import           Data.Char        as C (isDigit)
import           Data.List        as L (delete, intersect, (\\))
import           Data.Maybe       as A (fromJust, isJust)
import           System.Directory as D (removeFile, renameFile)
import           System.IO        as I (Handle, hClose, hPutStr, openTempFile)

data Container = Container {args             :: [String],
                            home             :: FilePath,
                            handle           :: I.Handle,
                            contents         :: [String],
                            numberedContents :: [String],
                            toDoPath         :: FilePath
                           } deriving (Show, Eq)

remover :: Container -> IO ()
remover container
    | null (args container) = removeToDo container
    | otherwise = do
        (tempName, tempHandle) <- I.openTempFile (home container ++ "/.config/") "temp"
        let newToDo = checkPattern (contents container) (args container)
        I.hPutStr tempHandle (unlines newToDo)
        I.hClose (handle container)
        I.hClose tempHandle
        D.removeFile (toDoPath container)
        D.renameFile tempName (toDoPath container)


indexremover :: [String] -> [Int] -> [String]
indexremover xs ys
    | null xs = []
    | null ys = xs
    | otherwise = indexremover (L.delete (xs !! head ys) xs) (drop 1 $ map (\x -> x - 1) ys)

removeToDo :: Container -> IO ()
removeToDo container = do
    (tempName, tempHandle) <- I.openTempFile (home container ++ "/.config/") "temp"
    putStrLn "Which of your TODOs would you like to remove? (Input indices only)"
    mapM_ putStrLn (numberedContents container)
    num <- getLine
    M.when (catchStr num) $ error "Input contains characters that are not digits!"
    let newToDo = checkPattern (contents container) (words num)
    I.hPutStr tempHandle (unlines newToDo)
    I.hClose (handle container)
    I.hClose tempHandle
    D.removeFile (toDoPath container)
    D.renameFile tempName (toDoPath container)

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

catchStr :: String -> Bool
catchStr = not . all C.isDigit
