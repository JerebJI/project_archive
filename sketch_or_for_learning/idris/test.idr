module Main

data Vect : Type -> Nat -> Type where
     Nil  : Vect a 0
     (::) : a -> Vect a k -> Vect a (S k)

(++) : Vect a m -> Vect a n -> Vect a (m+n)
(++) []      ys = ys
(++) (x::xs) ys = x :: xs ++ ys

total
vAdd : Num a => Vect a n -> Vect a n -> Vect a n
vAdd []      []      = []
vAdd (x::xs) (y::ys) = x + y :: vAdd xs ys

vApp : Vect (a->a) n -> Vect a n -> Vect a n
vApp []      []      = []
vApp (x::xs) (y::ys) = (x y) :: vApp xs ys


data Or a b = Inl a | Inr b
data And a b = And_intro a b

th1 : a -> Or a b
th1 x = Inl x

th2 : a -> b -> And a b
th2 x y = And_intro x y

plus_n0 : (n : Nat) -> n + 0 = n
plus_n0 0 = refl
plus_n0 (S k) = ?plus_Scase
