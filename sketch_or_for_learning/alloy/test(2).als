sig D {}
sig X in D { Px : Y }
sig R in X {}
sig Y in D { Py : X }
assert test {
  !(some x:X | x in R or all y:Y | !(y in x.Px) or (x in y.Py))
}
