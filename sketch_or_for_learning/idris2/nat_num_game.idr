ex1 : (x,y,z:Nat) -> x*y+z = x*y+z
ex1 x y z = Refl

ex2 : (x,y:Nat) -> y=x+7 -> 2*y = 2 * (x+7)
ex2 x y h = rewrite h in Refl

ex3 : (a,b:Nat) -> S a=b -> S(S a)=S b
ex3 a b h = rewrite h in Refl

add_zero : (a:Nat) -> a+Z=a
add_zero Z = Refl
add_zero (S k) = cong S (add_zero k)

add_succ : (a,d:Nat) -> a+(S d)=S(a+d)
add_succ Z d = Refl
add_succ (S k) d = cong S (add_succ k d)

add_succ_zero : (a:Nat) -> a+(S Z) = (S a)
add_succ_zero a = rewrite add_succ a Z in
                  rewrite add_zero a in Refl

add_assoc : (a,b,c:Nat) -> (a+b)+c = a+(b+c)
add_assoc a b Z = rewrite add_zero (a+b) in rewrite add_zero b in Refl
add_assoc a b (S k) = rewrite add_succ (a+b) k in
                      rewrite add_succ b k in
                      rewrite add_succ a (plus b k) in
                      cong S (add_assoc a b k)

succ_add : (a,b:Nat) -> (S a)+b = S(a+b)
succ_add a b = cong S Refl

add_comm : (a,b:Nat) -> a+b = b+a
add_comm a Z = rewrite add_zero a in Refl
add_comm a (S k) = rewrite add_succ a k in cong S (add_comm a k)

succ_eq_add_one : (n:Nat) -> (S n) = n + (S Z)
succ_eq_add_one n = rewrite add_succ n Z in
                    rewrite add_zero n in Refl

add_right_assoc : (a,b,c:Nat) -> a+b+c = a+c+b
add_right_assoc a b c = rewrite add_assoc a b c in ?h
