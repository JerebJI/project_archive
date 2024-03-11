import Data.List
import Data.Char

type ErrorMessage = String
asIntf :: String -> Either ErrorMessage Int
asIntf []          = Left "Empty"
asIntf "-"         = Left "Incomplete"
asIntf ('-':'-':s) = Left "Illegal '--'"
asIntf ('-':s)     = case asIntf s of
                       (Right x) -> Right(-x)
                       x         -> x
asIntf s           = foldl' (fn) (Right 0) s
fn (Left x) _ = Left x
fn (Right x) y
    | y`notElem`['0'..'9'] = Left $ (show y)++" is not a digit."
    | x+(digitToInt y)<x                = Left "Overflow"
    | otherwise            = Right $ x*10+(digitToInt y)

conc xs = foldr (++) [] xs
