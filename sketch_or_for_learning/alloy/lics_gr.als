module AboutGraphs

sig Element {}

one sig Graph {
  nodes : set Element,
  edges : nodes -> nodes
}

pred refl {
  (all g : Graph |
    all x : Graph.nodes | 
      (x in (g.edges[x])))
}

pred simetr {
  (all g : Graph |
    all x,y : g.nodes | 
      (y in g.edges[x]) implies (x in g.edges[y]))
}

pred tranz {
  all g : Graph |
    all x,y,z : g.nodes | 
      (y in g.edges[x] and z in g.edges[y]) 
      implies (z in g.edges[x])
}

pred b {
//  all e : Element | some g : Graph | e in g.nodes
//  some g : Graph | #g.edges = 7
  some g : Graph | #(g.nodes)=7
  all g : Graph | all n : g.nodes | #((^(g.edges))[n])=5
}

pred c {
  all g : Graph | 
    #g.nodes=4 and
    #g.edges=4 and
    all n : g.nodes |
      n in (^(g.edges))[n] and
      all m : g.nodes | n in (^(g.edges))[m]
}
