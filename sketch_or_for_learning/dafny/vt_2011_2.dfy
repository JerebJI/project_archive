class Tree {
    var value : int
    var left : Tree?
    var right : Tree?

    ghost var Repr : set<object>
    ghost var Values : set<int>
    ghost predicate Valid()
    reads this,Repr
    ensures Valid() ==> this in Repr
    decreases Repr
    {
        this in Repr &&
        (left!=null ==> left  in Repr && left.Repr<Repr  && left.Valid()) &&
        (right!=null ==> right in Repr && right.Repr<Repr && right.Valid()) &&
        (left!=null && right!=null ==>
          left.Repr !! right.Repr)
        && Values == {value} //!!!!
                  + (if left!=null  then left.Values  else {})
                  + (if right!=null then right.Values else {})
    }

    constructor ()
    ensures Valid()
    ensures fresh(Repr)
    {
        left,right := null,null;
        Repr := {this};
        Values := {value};
    }

    method max() returns (M:int)
    requires Valid()
    ensures M in Values
    ensures forall v :: v in Values ==> M >= v
    ensures Valid()
    decreases Repr
    {
        M := value;
        if (left!=null) {
            var Ml := left.max();
            M := if Ml>=M then Ml else M;
        }
        
        if (right!=null) {
            var Mr := right.max();
            M := if Mr>=M then Mr else M;
        }
    }
}