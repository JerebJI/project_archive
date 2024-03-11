import Data.List

class Meq a where
    jeen :: a -> a -> Bool
    jeen x y = not$nien x y
    nien :: a -> a -> Bool
    nien x y = not$jeen x y

instance Meq Bool where
    jeen True  True  = True
    jeen False False = True
    jeen _     _     = False

data Col = R|G|B

instance Show Col where
    show R = "Red"
    show G = "Green"
    show B = "Blue"

instance Read Col where
    readsPrec _ value =
        tryParse [("Red",R),("Green",G),("Blue",B)]
        where tryParse [] = []
              tryParse ((att,res):xs) =
                  if(take(length att)value)==att
                      then [(res,drop(length att) value)]
                      else tryParse xs
