sig Client {}
abstract sig Table {}
one sig One,Two,Three extends Table {}

// Specify the following properties assuming the following events can happen.

// reserve[c,t] iff client c reserves table t
// use[c,t] iff client c uses table t
// stutter iff nothing happens

// http://alloy4fun.inesctec.pt/sKLTRjXh6Ad9o3XQn

pred prop1 {
	// Clients can use at most one table at a time
    always (all c:Client | all t1,t2:Table |
      (use[c,t1] and use[c,t2]) implies t1=t2)
}


pred prop2 {
	// Clients can only use previously reserved tables
    all c:Client | always all t:Table | (use[c,t] implies once reserve[c,t])
}


pred prop3 {
	// There should always be at least one unused table
    always (some t:Table | all c:Client | not use[c,t])
}


pred prop4 {
	// Clients must use all the tables they reserve
    all c:Client,t:Table | always (reserve[c,t] implies after eventually use[c,t])
}


pred prop5 {
	// Table two can only be used after table one
    (some c:Client | use[c,One]) releases
       all c:Client | not use[c,Two]
}


pred prop6 {
	// Table three can only be used after tables one and two have been used
    always((some c:Client | use[c,Three]) implies 
      before((once some c:Client|use[c,One])
         and (once some c:Client|use[c,Two])))
}


pred prop7 {
	// After using a table a client can only use it again after reserving it
    all c:Client,t:Table |
      always (use[c,t] implies after (reserve[c,t] releases not use[c,t]))
}


pred prop8 {
	// No one can use the same table for ever
    always all c:Client,t:Table | use[c,t] implies eventually not use[c,t]
}


pred prop9 {
	// Tables can only be used once
    always all t:Table,c:Client | 
      use[c,t] implies after always no c1:Client | use[c1,t]
}


pred prop10 {
	// Once in a while all the tables are free
    always eventually all t:Table, c:Client | not use[t,c]
}


pred prop11 {
	// If clients stop making reservations then tables will also stop being used 
    always ((always no c:Client,t:Table | reserve[c,t]) implies 
            eventually (always no c:Client,t:Table | use[c,t]))
}


pred prop12 {
	// Clients cannot use the same table twice in a row
    always all c:Client,t:Table | use[c,t] implies after not use[c,t]
}
