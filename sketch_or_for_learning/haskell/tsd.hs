import System.IO
import System.Random
import Data.List
import Control.Monad

data Stopnja = To | II | III | Su | Do | VI | VII deriving (Eq,Ord,Show,Read,Enum,Bounded)
data Ton = C | Cis | D | Dis | E | F | Fis | G | Gis | A | Ais | H deriving (Eq,Ord,Show,Read,Enum,Bounded)
{-
type Des = Cis
type Es = Dis
type Eis = F
type Ges = Fis
type As = Gis
type B = Ais
type His = C
-}

--type Toni = [String]
type Lestvica = [Int]

sToni = cycle ["his/c","cis/des","d","dis/es","e","eis/f","fis/ges","g","gis/as","a","ais/b","h"]
stopnje = ["T","II","III","S","D","VI","VII"]
--toni = [minBound .. maxBound] :: [Ton]
--stopnje = [minBound .. maxBound] :: [Stopnja]
dur  = cycle [2,2,1,2,2,2,1] :: [Int]
nmol = cycle [2,1,2,2,1,2,2] :: [Int]
hmol = cYCle [2,1,2,2,1,3,1] :: [Int]
mmol = cycle [2,1,2,2,2,2,1] :: [Int]

tsd = [1,4,5]

stopVton :: Ton -> Lestvica -> Int -> String
stopVton x y z = sToni !! (l !! (z-1))
               where l = scanl (+) (fromEnum x) y

main :: IO()
main = do
  g <- getStdGen
  -- l <- take 10 (randomRs(0,2::Int)g)
  print . map(stopVton E dur). map(tsd!!) $ take 10 (randomRs(0,2::Int)g)
