import Data.List as List
newtype Probability = P Float
newtype Dist a = D {unD :: [(a,Probability)]}
type Spread a = [a] -> Dist a
type Event a = a -> Bool

unP (P p) = p

instance Show Probability where
  show (P p) = show(p*100)++"%"

instance Show a => Show (Dist a) where
  show (D d) = List.foldl (\x y->x++"\n"++y) "" [(show x)++" "++(show p)|(x,p)<-d]

uniform :: Spread a
uniform ls = D [(l,P p) | l<-ls] where p=1.0 / (fromIntegral$length ls)
die = uniform [1..6]

(??) :: Event a -> Dist a -> Probability
(??) p = P . sum . map (unP.snd) . filter (p.fst) . unD

joinWith :: (a -> b -> c) -> Dist a -> Dist b -> Dist c
joinWith f (D d) (D d') = D [(f x y,P (p*q)) | (x,P p)<-d, (y,P q)<-d']

prod :: Dist a -> Dist b -> Dist (a,b)
prod = joinWith (,)

certainly x = D [(x,P 1)]

dice :: Int -> Dist[Int]
dice 0 = certainly []
dice n = joinWith (:) die (dice (n-1))

instance Functor Dist where
  fmap f (D d) = D [(f x,P p) | (x,P p)<-d]

instance Applicative Dist where
  pure x = D [(x,P 1)]
  (D f) <*> (D d) = D [(y x,P (p*q)) | (x,P p)<-d, (y,P q)<-f]

instance Monad Dist where
  --return x  = D [(x,1)]
  (D d)>>=f = D [(y,P (p*q)) | (x,P p)<-d, (y,P q)<-unD(f x)]

selectOne :: Eq a => [a] -> Dist (a,[a])
selectOne c = uniform [(v,List.delete v c) | v<-c]
selectMany 0 c = return ([],c)
selectMany n c = do (x,c1)  <- selectOne c
                    (xs,c2) <- selectMany (n-1) c1
                    return (x:xs,c2)

select :: Eq a => Int -> [a] -> Dist [a]
select n = fmap (reverse.fst) . selectMany n

type Trans a = a -> Dist a

data Outcome = Win | Lose deriving Show
firstChoice :: Dist Outcome
firstChoice = uniform [Win,Lose,Lose]
switch :: Trans Outcome
switch Win = certainly Lose
switch Lose = certainly Win
