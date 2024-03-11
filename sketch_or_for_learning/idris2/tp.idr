fif : 2+3 = 5
fif = Refl

plusRed : (n:Nat) -> plus Z n = n
plusRed n = Refl

plusRedZ : (n:Nat) -> n=plus n Z
plusRedZ Z = Refl
plusRedZ (S k) = cong S (plusRedZ k)
