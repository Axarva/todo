module Helpers where

import System.IO as I ( Handle )
import Add ( adder, appendToDo )
import Remove ( removeToDo, remover, Container(..) )
import View ( displayToDo )
import qualified Data.Map as M
import Maps ( commands, inputs )
import Strings (auxErr, nullArgsInteract)

helper :: Container -> IO ()
helper container
    | null (args container) = do
                mapM_ putStrLn nullArgsInteract
                line <- getLine
                inpHandler line container
    | otherwise = auxHelper container

inpHandler :: [Char] -> Container -> IO ()
inpHandler x container
    = maybeDoIO stuff fallback
    where stuff = M.lookup x $ inputs container
          fallback = putStrLn $ "Unknown Command: " ++ x ++ "\nQuitting."

auxHelper :: Container -> IO ()
auxHelper container
    = maybeDoIO stuff fallback
    where header = head (args container)
          stuff = M.lookup header $ commands container
          fallback = mapM_ putStrLn $ auxErr header

maybeDoIO :: Maybe (IO ()) -> IO () -> IO ()
maybeDoIO (Just io) fallback = io
maybeDoIO Nothing fallback = fallback
