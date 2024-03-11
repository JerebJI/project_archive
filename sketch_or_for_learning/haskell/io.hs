main = do
       putStrLn "Pozdrav! Kako ti je ime?"
       inpStr <- getLine
       putStrLn $ "Dobrodošel v Haskellu, " ++ inpStr ++ "!"
