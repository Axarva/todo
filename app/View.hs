module View (displayToDo) where
    
import Remove ( Container(numberedContents) )

displayToDo :: Container -> IO ()
displayToDo container = do
    putStrLn "Here are your TODOs! :"
    mapM_ putStrLn (numberedContents container)
