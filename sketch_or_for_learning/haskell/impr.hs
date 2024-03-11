{-# LANGUAGE DeriveFoldable, DeriveFunctor #-}
import Data.Foldable
import Data.Functor
import Data.Semigroup
data Tree a = Empty | Leaf a | Node (Tree a) a (Tree a) deriving (Foldable,Functor,Show)
t :: Tree Int
t = Node (Node (Leaf 8) 4 (Leaf 3)) 2 (Leaf (-3))
