sig Machine {
   nextm : one Machine,
   var state : one State
}
one sig BottomMachine in Machine {}
sig State {
   nexts : one State
}
pred ValidState {
  nexts in State one -> one State
  all s:State | State in s.(*nexts)
}
pred ValidTopology {
  nextm in Machine one -> one Machine
  all m:Machine | Machine in m.(*nextm)
}

fact {
   ValidState
   ValidTopology
}
run {
} for exactly 3 Machine, exactly 4 State
fun HasPrivilege : set Machine {
   { m : Machine | m=BottomMachine => m.nextm.state=m.state
                                 else m.nextm.state!=m.state}
}
fact {
   always all m:Machine |
     (m in HasPrivilege => (m=BottomMachine => m.state'=m.state.nexts
                                         else m.state'=m.nextm.state)
                      else m.state'=m.state)
     or m.state'=m.state
}
pred LegitimateState {
   one HasPrivilege
}
fact {
   (#State > #Machine)
   or  (#State >= #Machine and
     always(one m:HasPrivilege | m.state'!=m.state))
}
check {
   eventually LegitimateState
   always (LegitimateState implies always LegitimateState)
} for 30 steps
run {
   eventually LegitimateState
   #HasPrivilege > 1
} for exactly 3 Machine, exactly 4 State, 30 steps
