sig Element {}

one sig Graph {
  nodes : set Element,
  edges : nodes -> nodes
}

sig Color {}
one sig AboutColoredGraphs {
  graph : Graph,
  color : set Element -> one Color
}{ graph.nodes=color.univ and
    all n,m : graph.nodes | m in graph.edges[n] implies not color[m]=color[n]}

pred kcol[k:Int] {
  #Color>=k
  all g : AboutColoredGraphs |
    #(univ.(g.color))>=k
}

pred test {
  kcol[3]
  not kcol[2]
}

run test
