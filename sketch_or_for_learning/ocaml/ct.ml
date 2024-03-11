let id x = x
let comp f g x = f(g x)
let t x = 2
let test x = ((comp (id) (t)) x) = ((comp (t) (id)) x)
