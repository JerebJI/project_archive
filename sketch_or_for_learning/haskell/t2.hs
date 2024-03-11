import Data.List
import Data.Function
data Roygbiv = Red|Orange|Yellow|Green|Blue|Indigo|Violet deriving (Eq,Show,Read)
data List a= Cons a (List a) | Nil deriving (Show)
--data Tree a = Node a [Tree a] [Tree a] deriving (Show)
len :: [a] -> Int
len xs = loop 0 xs
    where loop l (y:ys) = loop (l+1) ys
          loop l []     = l 
len1 xs = foldl s 0 xs
    where s x y = x+1
len2 xs = foldl (\x y->x+1) 0 xs
avg xs = ((sum) xs) / (fromIntegral(length xs))
pal xs = xs ++ (reverse xs)
ispal xs = xs==(reverse xs)
sorl xs = sortBy (\x y->(compare `on` length) x y) xs
a = sorl [[1,2],[1],[]]
inter a xs = foldl1 (\x y->x++(a:y)) xs
inter1 a (x:xs) = x++(a:(l xs))
    where l (y:ys) = a:(l ys)
          l _      = []

data BinTree a = Node a (BinTree a) (BinTree a) | Nic deriving (Show)
--h :: BinTree a -> Int
h Nic = 1
h (Node _ l r)   = 1 + (max (h l) (h r))

data Dir = L|R|S deriving (Show)
fold3 f (x:y:z:xs) = (f x y z):(fold3 f (y:z:xs))
fold3 f _ =  []

--foldx x f xs = foldx x (al x (f) (take x xs)) (drop x xs)
--al 1 f (x:_) = f x
--al 2 f (x:y:_) = f x y
--al 3 f (x:y:z:_) = f x y z
--al 4 f (x:y:z:w:_) = f x y z w
--al _ f _ = error "preveč"

--applyl f (x:xs) = applyl (f x) xs
--applyl f _      = f
