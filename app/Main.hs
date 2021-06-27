module Main where

import qualified Control.Monad      as M
import qualified Data.Char          as C
import qualified Data.List          as L
import qualified Data.Maybe         as A
import qualified System.Directory   as D
import qualified System.Environment as E
import qualified System.IO          as I
import qualified Text.Read          as R

main :: IO ()
main = do
    args <- E.getArgs
    home <- D.getHomeDirectory
    let toDoPath = if length args >= 2 && ".txt" `L.intersect` (args !! 1) == ".txt" then args !! 1 else home ++ "/.config/todo.txt"
    fileExist <- D.doesFileExist toDoPath
    M.unless fileExist $ I.writeFile toDoPath ""
    handle <- I.openFile toDoPath I.ReadMode
    contents <- lines <$> I.hGetContents handle
    let numberedContents = zipWith (\n line -> show n ++ " - " ++ line) [1..] contents
    case args of
        [] -> do
                putStrLn "What would you like to do?"
                putStrLn "1. View your TODOs"
                putStrLn "2. Add a TODO"
                putStrLn "3. Remove a TODO"
                line <- getLine
                let inp = parser line
                case inp of
                    Just "1" -> displayToDo numberedContents
                    Just "2" -> appendToDo toDoPath handle
                    Just "3" -> removeToDo home handle contents numberedContents toDoPath
                    Just "q" -> putStrLn "Quitting."
        x:xs ->  case head (Just <$> args) of
                    Just "view" -> displayToDo numberedContents
                    Just "add" -> if toDoPath == home ++ "/.config/todo.txt" then
                                     adder (drop 1 args) toDoPath handle
                                  else adder (drop 2 args) toDoPath handle
                    Just "remove" -> if toDoPath == home ++ "/.config/todo.txt" then
                                        remover (drop 1 args) home handle contents numberedContents toDoPath
                                    else remover (drop 2 args) home handle contents numberedContents toDoPath
                    Nothing -> return ()
    I.hClose handle

appendToDo :: FilePath -> I.Handle -> IO ()
appendToDo toDoPath handle = do
        I.hClose handle
        putStrLn "Write your new TODO here:"
        todoItem <- getLine
        appendFile toDoPath (todoItem ++ "\n")

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

displayToDo :: Foldable t => t String -> IO ()
displayToDo numberedContents = do
    putStrLn "Here are your TODOs! :"
    mapM_ putStrLn numberedContents

adder :: Foldable t => t String -> FilePath -> I.Handle -> IO ()
adder args toDoPath handle
    | null args = appendToDo toDoPath handle
    | otherwise = do
        I.hClose handle
        mapM_ (appendFile toDoPath) args

readToInt :: String -> Maybe Int
readToInt = R.readMaybe

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

parser :: String -> Maybe String
parser x
  | null x = Nothing
  | x `elem` ["1","2","3","q"] = Just x
