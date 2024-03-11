------------------------------- MODULE posode -------------------------------
EXTENDS Integers
VARIABLES small, big

TypeOK == /\ small \in 0..3
          /\ big   \in 0..5

Init == /\ big  = 0
        /\ small = 0

FillSmall == /\ small' = 3
             /\ big'   = big

FillBig == /\ big'   = 5
           /\ small' = small

SmallToBig == IF big+small <= 5
                THEN /\ big'   = big + small
                     /\ small' = 0
                ELSE /\ big'   = 5
                     /\ small' = small-(5-big)
        
BigToSmall == IF big+small <= 3
                THEN /\ small' = big + small
                     /\ big'   = 0
                ELSE /\ small' = 3
                     /\ big'   = big-(3-small)

EmptySmall == /\ small' = 0
              /\ big'   = big
              
EmptyBig == /\ small' = small
            /\ big'   = 0
                     
Next == \/ FillSmall
        \/ FillBig
        \/ EmptySmall
        \/ EmptyBig
        \/ SmallToBig
        \/ BigToSmall

=============================================================================
\* Modification History
\* Last modified Mon Jul 31 18:47:34 CEST 2023 by janezij
\* Created Mon Jul 31 18:34:04 CEST 2023 by janezij
