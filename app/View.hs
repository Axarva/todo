module View (displayToDo) where

displayToDo :: Foldable t => t String -> IO ()
displayToDo numberedContents = do
    putStrLn "Here are your TODOs! :"
    mapM_ putStrLn numberedContents
