sig Node {
  var first : lone Node,
  conn : set Node
}
one sig Initiator in Node {}
pred ValidNetworkTopology {
  all n:Node | Node in n.*conn // all nodes connected
  all n:Node,m:Node | m in n.conn implies n in m.conn // bidirectional connection
  no n:Node | n in n.conn
}

abstract var sig Message {
  var sender : Node,
  var receiver : Node
}
abstract var sig ControlMessage extends Message {}
var sig ExplorerMessage extends ControlMessage {}
var sig EchoMessage extends ControlMessage {}
//var sig BasicMessage extends Message {}

fun inbox[n:Node] : set Message {
  { m : Message | m.receiver = n }
}

fun outbox[n:Node] : set Message {
  { m : Message | m.sender = n }
}

pred End {
  all n:Node | one n.first
}

pred output[s:Node,exr,ecr:set Node] {
  all m:sender.s, mr:m.receiver | {
    m in ExplorerMessage => mr in exr
    m in EchoMessage     => mr in ecr
  }
  all e:exr | one m:ExplorerMessage | m.sender=s and m.receiver=e
  all e:ecr | one m:EchoMessage     | m.sender=s and m.receiver=e
}

pred iteration {
  all m:ControlMessage, r:m.receiver, s:m.sender |
    m in ExplorerMessage => {
      no r.first => {
        r.first'=s
        no r.conn-s => after output[r,none,s]
                  else after output[r,r.conn-s,none]
      } else {
        r.first' = r.first
        after output[r,none,s]
      }
    } else m in EchoMessage => {
      r.first'=r.first
      (all n:r.conn-s | once some em:EchoMessage | em.sender=n and em.receiver=r) => {
        output[r,none,r.first]
      } else output[r,none,none]
    } else {
      r.first'=r.first
      output[r,none,none]
    }
  all n:Node | n !in ControlMessage.receiver => {
    n.first'=n.first
    after output[n,none,none]
  }
}

fact {
  ValidNetworkTopology
  // Valid Initiator
  Initiator.first = Initiator // initiator is its own first node
  // Valid message state
  always all m:Message, s:m.sender, r:m.receiver | r in s.conn
  // Valid initial state
  all n:Node-Initiator | no n.first
  no EchoMessage // no echo messages
  all e:ExplorerMessage | e.sender = Initiator and e.receiver in Initiator.conn // explorer messages only from Initiator
  output[Initiator,Initiator.conn,none] // explorer message to all conn nodes
  // Next states
  always iteration
}

check {
  eventually End
  End implies after all n:Node | n.first'=n.first
  End implies all n:Node | Initiator in n.*first
  End implies all n:Node-Initiator | n !in n.^first
} for 5

run {
  // ok Initiator.conn.first!=Initiator
} for 5 but exactly 5 Node, exactly 5 steps
