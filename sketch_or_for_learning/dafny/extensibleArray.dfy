class ExtensibleArray<T> {
  ghost var Elements: seq<T>
  ghost var Repr: set<object>
  var front: array?<T>
  var depot: ExtensibleArray?<array<T>>
  var length: int
  var M: int // shorthand for:
             // if depot == null then 0 else 256 * |depot.Elements|
  ghost predicate Valid()
    reads this, Repr
    ensures Valid() ==> this in Repr
  {
    this in Repr &&
    (front != null ==>
      front.Length == 256 && front in Repr) &&
    (depot != null ==>
      depot in Repr && depot.Repr <= Repr &&
      this !in depot.Repr && depot.Valid() &&
     front !in depot.Repr &&
     forall j :: 0 <= j < |depot.Elements| ==>
        depot.Elements[j].Length == 256 &&
        depot.Elements[j] in Repr &&
        depot.Elements[j] !in depot.Repr &&
        depot.Elements[j] != front &&
        forall k :: 0 <= k < |depot.Elements| && k != j ==>
          depot.Elements[j] != depot.Elements[k]) &&
    M == (if depot == null then 0 else 256 * |depot.Elements|) &&
    M <= length < M + 256 &&
    (length == M <==> front == null) &&
    length == |Elements| &&
    (forall i :: 0 <= i < M ==>
      Elements[i] == depot.Elements[i / 256][i % 256]) &&
    (forall i :: M <= i < length ==>
      Elements[i] == front[i - M])
  }
  constructor ()
    ensures Valid() && fresh(Repr) && Elements == []
  {
    front,depot := null,null;
    length, M := 0, 0;
    Elements, Repr := [], {this};
  }
  function Get(i: int): T
    requires Valid() && 0 <= i < |Elements|
    ensures Get(i) == Elements[i]
    reads Repr
  {
    if M<=i then
      front[i-M]
    else
      var arr := depot.Get(i/256);
      arr[i%256]
  }
  method Update(i: int, t: T)
    requires Valid() && 0 <= i < |Elements|
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
    ensures Elements == old(Elements)[i := t]
  {
    if M<=i {
        front[i-M]:=t;
    } else {
        var arr := depot.Get(i/256);
        arr[i%256] := t;
    }
    Elements := Elements[i:=t];
  }
  method Append(t: T)
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
    ensures Elements == old(Elements) + [t]
    decreases |Elements|
  {
    if front==null {
        front := new T[256](_ => t);
        Repr := Repr + {front};
    }
    front[length-M] := t;
    length := length + 1;
    Elements := Elements + [t];
    if length==M+256 {
        if depot == null {
            depot := new ExtensibleArray();
            Repr := Repr + depot.Repr;
        }
        depot.Append(front);
        Repr := Repr + depot.Repr;
        M := M+256;
        front := null;
    }
  }
}

method ExtensibleArrayTestHarness() {
    var a := new ExtensibleArray<int>();
    a.Append(3);
    a.Append(3);
    assert a.Get(0)==a.Get(1) && a.Get(0)==3;
    var b := new ExtensibleArray<int>();
    b.Append(3);
    b.Append(4);
    assert b.Get(0)==a.Get(1) && b.Get(1)==4;
}