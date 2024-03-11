fc :: (b->c)->(a->b)->a->c
fc f g = \x -> f(g x)
