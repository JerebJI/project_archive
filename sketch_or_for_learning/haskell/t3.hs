import System.Environment (getArgs)
import Data.List
import Data.List.Split
{-
interactEith fun inFule outFile = do
    input <- readFile inFile
    writeFile outFile (fun input)

main = mainWith fun
    where mainWith f = do
        args <- getArgs
        case args of
          [input,output] -> interactWith f input output
          _ -> putStrLn "error: exactly 2 arguments needed"
      fum=id
-}
splitLines [] = []
splitLines cs =
    let (pre,suf)=break isLineTerminator cs
    in pre:case suf of
        ('\r':'\n':rest) -> splitLines rest
        ('\r':rest)      -> splitLines rest
        ('\n':rest)      -> splitLines rest
        _                -> []
isLineTerminator c = c=='\r'||c=='\n'

-- IZREDNO NEUČINOVIT !!
sl "" = []
sl cs = filter (not.null) $ foldl f [[]] cs
    where f o '\n' = o++[[]]
          f o '\r' = o++[[]]
          f o c    = (init o)++[(last o)++[c]]

sl1 = split (dropDelims.condense$oneOf "\n\r")

sHead :: [a] -> Maybe a
sHead []    = Nothing
sHead (x:_) = Just x

sTail :: [a] -> Maybe [a]
sTail (_:xs) = Just $ xs
sTail _      = Nothing

sLast :: [a] -> Maybe a
sLast [] = Nothing
sLast xs = Just $ last xs

splWith :: (a->Bool) -> [a] -> [[a]]
splWith _ [] = []
splWith f xs =
    let (p,s) = break f xs
    in p:(splWith(f)$stail s)
        where stail [] = []
              stail xs = tail xs
mf p xs = reverse$foldl (\x y->if not$p y then y:x else x) [] xs
