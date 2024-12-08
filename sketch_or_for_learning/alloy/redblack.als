abstract sig Node {}

abstract sig Red extends Node {}
abstract sig Black extends Node {}

sig RedN extends Red {
   rleft : one Black,
   rright : one Black
}

sig BlackN extends Black {
   bleft : one Node,
   bright : one Node
}

sig Nil extends Black {}

pred inv1 {
    // Every node is either red or black
    // velja zaradi abstract sig
}

pred inv2 {
   // All NIL nodes (figure 1) are considered black
   // velja, ker Nil extends black
}

pred inv3 {
   // A red node does not have a red child
   // iz definicije RedN
}

pred inv4 {
   // Every path from a given node to any of its descendant NIL nodes 
   // goes through the same number of black nodes
   all n : Node-Nil | some num : Int | num>=0 and
         all nn : Nil&n.^(rleft+rright+bleft+bright)
         | num = #(n.^(rleft+rright+bleft+bright) 
                           & Black 
                           & ^(rleft+rright+bleft+bright).nn)
}

pred noCycles {
   all n : RedN+BlackN | n not in n.^(rleft+rright+bleft+bright)
}

pred relNum {
   rleft in RedN lone -> one Black
   rright in RedN lone -> one Black
   bleft in BlackN lone -> one Node
   bright in BlackN lone -> one Node
}

pred root {
   some n : Node | Node in n+n.^(rleft+rright+bleft+bright)
}

pred oneParent {
   all n : Node | lone (rleft+rright+bleft+bright).n
}

pred noSame {
   all n : Node-Nil | #n.(rleft+rright+bleft+bright)=2
}

pred inv5 {
   // je drevo...
   noCycles
   relNum
   root
   oneParent
   noSame
}

run {
inv1
inv2
inv3
inv4
inv5
#BlackN >1
} for 10
