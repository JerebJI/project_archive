sig Workstation {
	workers : set Worker,
	succ : set Workstation
}
one sig begin, end in Workstation {}

sig Worker {}
sig Human, Robot extends Worker {}

abstract sig Product {
	parts : set Product	
}

sig Material extends Product {}

sig Component extends Product {
	workstation : set Workstation
}

sig Dangerous in Product {}
// Specify the following properties.
// You can check their correctness with the different commands and
// when specifying each property you can assume all the previous ones to be true.

pred inv1 {
	// Workers are either human or robots
          no Worker - Human - Robot
}


pred inv2 {
	// Every workstation has workers and every worker works in one workstation
          workers in Workstation one -> some Worker
}

pred inv3 {
	// Every component is assembled in one workstation
          workstation in Component -> one Workstation
}


pred inv4 {
	// Components must have parts and materials have no parts
           parts in Component -> some Product
}


pred inv5 {
	// Humans and robots cannot work together
          all w : Workstation | w.workers in Human or w.workers in Robot
}


pred inv6 {
	// Components cannot be their own parts
           all c : Component | c not in c.^parts
}


pred inv7 {
	// Components built of dangerous parts are also dangerous
          all c : Component | some c.^parts & Dangerous implies c in Dangerous
}


pred inv8 {
	// Dangerous components cannot be assembled by humans
          all c : Component&Dangerous | c.workstation.workers in Robot
}


pred inv9 {
	// The workstations form a single line between begin and end
          succ in Workstation lone -> lone Workstation
          Workstation-begin in begin.^succ
          no end.succ
          all ws : Workstation-begin | some w : Workstation | ws in w.succ
}


pred inv10 {
	// The parts of a component must be assembled before it in the production line
          all c : Component  | c.workstation in c.parts.workstation.^succ
}

run ex {
inv1
inv2
inv3
inv4
inv5
inv6
inv7
inv8
inv9
inv10
}
