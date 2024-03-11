------------------------------ MODULE TCommit ------------------------------
CONSTANT RM
VARIABLE rmState

TCTypeOK == rmState \in [RM -> {"working", "prepared", "committed", "aborted"}]

TCInit == rmState = [r \in RM |-> "working"]

Prepare(r) == /\ rmState[r] = "working"
              /\ rmState'   = [rmState EXCEPT ![r] = "prepared"]

canCommit == \A r \in RM : rmState[r] \in {"prepared","commited"}

notCommitted == \A r \in RM : rmState[r] /= "commited"

Decide(r) == \/ /\ rmState[r] = "prepared"
                /\ canCommit
                /\ rmState' = [rmState EXCEPT ![r] = "commited"]
             \/ /\ rmState[r] \in {"working", "prepared"}
                /\ notCommitted
                /\ rmState' = [rmState EXCEPT ![r] = "aborted"]

TCNext == \E r \in RM : Prepare(r) \/ Decide(r)

=============================================================================
\* Modification History
\* Last modified Mon Jul 31 19:53:07 CEST 2023 by janezij
\* Created Mon Jul 31 18:59:06 CEST 2023 by janezij
