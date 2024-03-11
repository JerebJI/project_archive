data Knj=Knjiga Int String [String]
sk=[Knjiga 0 "kjlk" ["kjk"],Knjiga 1 "hgjhg" ["uziu","cvbc"],Knjiga 2 "ertetr" ["vcbv"]]
naslov (Knjiga _ n _) = n
main = interact f
     where f input = show (naslov (sk !! (read input)))
