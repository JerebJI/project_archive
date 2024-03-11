myFilter p xs = foldr step [] xs
    where step x ys | p x       = x : ys
                    | otherwise = ys

mFilter p xs = foldl step [] xs
    where step x ys | p x       = x : ys
                    | otherwise = ys
