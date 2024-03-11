{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE LiberalTypeSynonyms #-}

data Ex = forall a.  Ex a
data Count a = C {unC :: a} deriving Show
data Ret a = Ri (Count Int) | Rl [(a,a)]

lchoose :: [a] -> [(a,[a])]
lchoose as = ch [] as
  where
    ch l []    = []
    ch l (h:t) = ((h,l++t)):(ch (h:l) t)

lchooses :: Int -> [a] -> [([a],[a])]
lchooses 1 as  = map (\x -> ([fst x],snd x)) $ lchoose as
lchooses n as = do (a,b) <- lchoose as
                   (c,d) <- lchooses (n-1) b
                   return (a:c,d)

lcombine :: [a] -> [a] -> [(a,a)]
lcombine as bs = [(a,b) | a<-as, b<-bs]

chse n 1 = n
chse n k
    | k > n     = -1
    | k > n - k = chse n  (n - k)
    | otherwise = ((chse n (k - 1)) * (n - k + 1)) `div` k

ichoose :: Count Int -> Count (Int, Count Int)
ichoose n = C(unC n,n)

ichooses :: Int -> Count Int -> Count (Count Int, Count Int)
ichooses k (C n) = C $ (\x->(C k,C x)) $ chse n k

icombine :: Count Int -> Count Int -> Count Int
icombine (C a) (C b) = C (a*b)

-- morda se da tako????
class Comb f b a where
  choose  :: f a -> f (a, f a)
  chooses :: Int -> f a -> f (f a, f a)
  combine :: f a -> f a -> b

instance Comb [] [(a,a)] a where
  choose  = lchoose
  chooses = lchooses
  combine = lcombine

instance Comb Count (Count Int) Int where
  choose  = ichoose
  chooses = ichooses
  combine = icombine

instance Functor Count where
  fmap f (C a) = C $ f a

instance Applicative Count where
  pure          = C
  (C f)<*>(C a) = C $ f a

instance Monad Count where
  (C a)>>=f    = C $ unC $ f a

--fex :: Ex -> Count a
--fex (Ex a) = a

unR (Ri a) = a
--unR (Rl a) = a

--test :: (Monad m, Comb m b) => m b -> m (m b, b)
test x = do (a,b) <- chooses 2 x
            (c,d) <- choose b
    --        cmb   <- combine b d
            return (a,c)
