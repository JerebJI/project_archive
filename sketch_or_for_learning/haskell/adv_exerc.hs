data Tree a = Leaf | Node (Tree a) a (Tree a) deriving (Show)

inv_tup_tree :: Tree (Integer,Integer)
inv_tup_tree = itt (0,0)

itt :: (Integer,Integer) -> Tree (Integer,Integer)
itt (x,y) = Node (itt(x+1,y)) (x,y) (itt(x,y+1))

cut :: Integer -> Tree a -> Tree a
cut 0 _ = Leaf
cut _ Leaf = Leaf
cut x (Node t1 v t2) = Node (cut (x-1) t1) v (cut (x-1) t2)
