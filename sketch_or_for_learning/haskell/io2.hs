name2reply :: String -> String
name2reply name =
    "Pleased to meet you, " ++ name ++ ".\n" ++
    "Your name contains " ++ charcount ++ " characters."
    where charcount = show (length name)

main :: IO ()
main = do
       putStrLn "Greetings once again. What is yout name?"
       inpStr <- getLine
       let outStr = name2reply inpStr
       putStrLn outStr
