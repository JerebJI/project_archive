module KripkeModel

sig State {}
sig Prop {}
one sig StateMachine {
  init : some State,
  next : State -> State,
  final : set State,
  prop : State -> Prop
} { all f : final | no f.next }

fun reachable[m: StateMachine, is: set State]: set State {
  ((*(m.next))[is])
}

pred Reaches[sm:StateMachine, rs:set State] {
  rs in (*(sm.next))[sm.init]
}

pred DeadlockFree[m: StateMachine] {
  all rs : State | (Reaches[m, rs] and (no (m.next[rs]))) implies rs in m.final
}

pred Deterministic[m: StateMachine] {
  all s: (m.next).univ | s in State implies #(m.next[s])<=1
}

pred Reachability[m: StateMachine, p: Prop] {
  p in m.prop[(*(m.next))[m.init]]
}

pred Liveness[m: StateMachine, p: Prop] {
  all s : reachable[m,m.init] | some x : State | p in m.prop[x] and x in reachable[m,s]
}

run Liveness
run test {all m:StateMachine | #m.next>4}
