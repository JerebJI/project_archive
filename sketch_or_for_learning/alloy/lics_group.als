module Group

sig G {}
one sig Group {
  g : set G,
  op : g -> g -> one g,
  unit : g
} { all x,y:g | one op[x,y]
    all x:g | some y:g | op[x,y]=op[y,x] and op[x,y]=unit
    all x,y,z:g | op[x,op[y,z]] = op[op[x,y],z]
    all x: g | op[x,unit]=x and op[unit,x]=x}

fact {all x:G | some gr:Group | x in gr.g}
