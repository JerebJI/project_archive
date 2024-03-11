------------------------------ MODULE TCommit ------------------------------
CONSTANT RM
VARIABLE rmState

TCTypeOK == rmState \in [RM -> {"working", "prepared", "committed", "aborted"}]

TCConsistent == \A r1, r2 \in RM : ~ /\ rmState[r1] = "aborted"
                                     /\ rmState[r2] = "committed"

TCInit == rmState = [r \in RM |-> "working"]

Prepare(r) == /\ rmState[r] = "working"
              /\ rmState'   = [rmState EXCEPT ![r] = "prepared"]

canCommit == \A r \in RM : rmState[r] \in {"prepared","committed"}

notCommitted == \A r \in RM : rmState[r] /= "committed"

Decide(r) == \/ /\ rmState[r] = "prepared"
                /\ canCommit
                /\ rmState' = [rmState EXCEPT ![r] = "committed"]
             \/ /\ rmState[r] \in {"working", "prepared"}
                /\ notCommitted
                /\ rmState' = [rmState EXCEPT ![r] = "aborted"]

TCNext == \E r \in RM : Prepare(r) \/ Decide(r)

=============================================================================
\* Modification History
\* Last modified Mon Jul 31 20:00:14 CEST 2023 by janezij
\* Created Mon Jul 31 18:59:06 CEST 2023 by janezij
