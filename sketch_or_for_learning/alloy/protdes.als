open util/ordering[Id]

sig Node {
   succ : one Node,
   id : one Id,
  var inbox : set Id,
  var outbox : set Id
}

sig Id {}

var sig Elected in Node {}

fact {
  // initially inbox and outbox are empty
  no inbox and no outbox
  // initially there are no elected nodes
  no Elected
}

fact {
  all n : Node | Node in n.^succ
}

fact {
   some Node
}

fact {
  all i:Id | lone id.i
}

pred initiate[n : Node] {
  // node n initiates the protocol

  historically n.id not in n.outbox          // guard

  n.outbox' = n.outbox + n.id                // effect on n.outbox
  all m : Node - n | m.outbox' = m.outbox    // effect on the outboxes of other nodes

  inbox'   = inbox                           // frame condition on inbox
  Elected' = Elected                         // frame condition on Elected
}


pred stutter {
  outbox' = outbox
  inbox' = inbox
  Elected' = Elected
}

pred send[n : Node, i : Id] {
  // i is sent from node n to its successor

  i in n.outbox                              // guard

  n.outbox' = n.outbox - i                   // effect on n.outbox
  all m : Node - n | m.outbox' = m.outbox    // effect on the outboxes of other nodes

  n.succ.inbox' = n.succ.inbox + i           // effect on n.succ.inbox
  all m : Node - n.succ | m.inbox' = m.inbox // effect on the inboxes of other nodes

  Elected' = Elected                         // frame condition on Elected
}

pred process[n : Node, i : Id] {
  // i is read and processed by node n

  i in n.inbox                                // guard

  n.inbox' = n.inbox - i                      // effect on n.inbox
  all m : Node - n | m.inbox' = m.inbox       // effect on the inboxes of other nodes

  gt[i,n.id] implies n.outbox' = n.outbox + i // effect on n.outbox
             else    n.outbox' = n.outbox
  all m : Node - n | m.outbox' = m.outbox     // effect on the outboxes of other nodes

  i = n.id implies Elected' = Elected + n     // effect on Elected
           else Elected' = Elected
  }

fact {
  always (stutter or 
          some n:Node | initiate[n] or
          some n:Node, i:Id | send[n,i] or
          some n:Node, i:Id | process[n,i])
}
run example {
  eventually some Elected
} for exactly 3 Node, exactly 3 Id

assert AtMostOneLeader {
  fairness implies always (lone Elected)
}

assert AtLeastOneLeader {
  eventually (some Elected)
}

pred fairness {
  all n : Node, i : Id {
    (eventually always historically n.id not in n.outbox) implies (always eventually initiate[n])
    (eventually always i in n.inbox)                      implies (always eventually process[n,i])
    (eventually always i in n.outbox)                     implies (always eventually send[n,i])
  }
}
