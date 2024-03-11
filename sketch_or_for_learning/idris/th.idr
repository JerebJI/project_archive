module th

plus_n0 : (n : Nat) -> Z + n = n
plus_n0 Z = Refl
plus_n0 (S k) = Refl

data Parity : Nat -> Type where
     meven : Parity (n+n)
     modd  : Parity (S(n+n))

parity : (n:Nat)-> Parity n
parity Z     = meven {n=Z}
parity (S Z) = modd {n=Z}
parity (S(S k)) with (parity k) 
  parity (S (S (j+j)))     | meven ?= meven {n= S j}
  parity (S (S (S (j+j)))) | modd  ?= modd {n=S j}
