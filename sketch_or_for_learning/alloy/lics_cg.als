sig Element {}
sig Color {}
one sig AboutColoredGraphs {
  nodes : set Element,
  edges : nodes -> nodes,
  color : nodes -> one Color
}{ all n,m : nodes | m in edges[n] implies not color[m]=color[n]}

pred twocol [g:AboutColoredGraphs] {
  #Color=2
}

pred kcol [k:Int] {
  (#Color)=k
  all g : AboutColoredGraphs |
    #(univ.(g.color))=k
}

pred test {
  kcol[3]
  kcol[2]
}

run test
