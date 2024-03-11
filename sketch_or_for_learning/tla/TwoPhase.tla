------------------------------ MODULE TwoPhase ------------------------------

CONSTANT RM
VARIABLES rmState, tmState, tmPrepared, msgs

Messages == [type:{"Prepared"}, rm:RM]\cup[type:{"Commit","Abort"}]

TPTypeOK == /\ rmState \in [RM -> {"working", "prepared", "committed", "aborted"}]
            /\ tmState \in {"init", "done"}
            /\ tmPrepared \subseteq RM
            /\ msgs \subseteq Messages

TPInit == /\ rmState = [R \in RM |-> "working"]
          /\ tmState = "init"
          /\ tmPrepared = {}
          /\ msgs = {}
          
TMRcvPrepared(r) == /\ tmState = "init"
                    /\ [type |-> "Prepared", rm |-> r] \in msgs
                    /\ tmPrepared' = tmPrepared \ckup {r}
                    /\ UNCHANGED << rmState, tmState, msgs >>

TMCommit == /\ [type |-> "Commit"] \in msgs
            /\ tmState' = "done"

=============================================================================
\* Modification History
\* Last modified Mon Sep 18 17:09:26 CEST 2023 by janezij
\* Created Mon Jul 31 20:04:52 CEST 2023 by janezij
