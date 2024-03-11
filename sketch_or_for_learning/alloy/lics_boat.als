abstract sig Passanger {}
one sig Goat, Wolf, Cabbage, Farmer extends Passanger {}

one var sig State {
  var left : set Passanger,
  var right : set Passanger
} {no left & right}

pred init[s: State] {
  s.right=none
  s.left = Goat + Wolf + Cabbage + Farmer
  #s.left=4
}

fact constraints {
  always no s : State |
    (Goat+Wolf in s.left or Goat+Cabbage in s.left)
      and not Farmer in s.left or
    Goat+Wolf in s.right or Goat+Cabbage in s.right)
      and not Farmer in s.right
}

pred carry[s: State, p: Passanger] {
  p in s.left => s.left'=s.left-p and s.right'=s.right+p
  p in s.right => s.right'=s.right-p and s.left'=s.left+p
}

pred test[s:State] {
  init[s] and some p : Passanger | always carry[s,p]
}

run test
