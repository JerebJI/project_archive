abstract sig Node {}
one sig A,B,C extends Node {}
abstract sig Message {}
one sig Hello,World extends Message {}

// Specify the following properties assuming the following events can happen
// and that each node can only send or receive at most one message at a time.

// send[n, m] iff node n broadcasts message m
// receive[n,m] iff node n receives message m
// stutter iff nothing happens

// http://alloy4fun.inesctec.pt/o9LrywZ49JXGRwc3q

pred prop1 {
	// Nothing will ever happen
	always stutter
}


pred prop2 {
	// Every node will send something
    all n:Node | some m:Message | eventually send[n,m]
}


pred prop3 {
	// Node A only sends Hello messages
    always (all m:Message | send[A,m] implies m in Hello)
}


pred prop4 {
	// Any received message must have been sent before
    always (all n:Node,m:Message | receive[n,m] implies before once some s:Node | send[s,m])
}


pred prop5 {
	// All the nodes keep sending messages
    all n:Node | always eventually some m:Message | send[n,m]
}


pred prop6 {
	// Nodes will eventually stop sending messages
    all n:Node | eventually always no m:Message | send[n,m]
}


pred prop7 {
	// Nodes can only send a World after sending an Hello
    all n:Node | always (send[n,World] implies before once send[n,Hello])
}


pred prop8 {
	// Nodes can only send a World after receiving an Hello
    all n:Node | always (send[n,World] implies once receive[n,Hello])
}


pred prop9 {
	// The first event that can occur is sending an Hello
    (stutter until some n:Node | send[n,Hello]) or always stutter
}


pred prop10 {
	// Every sent message must be later received by all other nodes
    all s:Node,m:Message | 
      always (send[s,m] implies after all n:Node-s | eventually receive[n,m])
}


pred prop11 {
	// Nodes cannot send repeated messages
    all n:Node,m:Message | always (send[n,m] implies after always no send[n,m])
}

// TODO!!!!!!!
pred prop12 {
	// After a message is sent no other message can be sent until the former is received by some node
    all n:Node,m:Message | 
      always ((send[n,m]) implies
        (some r:Node-n |
          (receive[r,m] releases (stutter or 
                         all n1:Node-n,m1:Message-m|receive[n1,m1]))
          and eventually receive[r,m]))
}


pred prop13 {
	// At most one send or one receive can happen at each time
	always (stutter or one n:Node,m:Message | send[n,m] or receive[n,m])
}


pred prop14 {
	// The network can stutter for at most 2 steps
    always ((stutter;stutter) implies after after not stutter)
}


pred prop15 {
	// All the receives happen after all the sends
    all n:Node,m:Message | receive[n,m] implies after always
        all s:Node,sm:Message | not send[s,sm]
}
