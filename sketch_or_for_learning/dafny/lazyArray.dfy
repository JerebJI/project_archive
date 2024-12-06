module LazyArraym {
  export
    reveals LazyArray
    provides LazyArray.Elements, LazyArray.Repr, LazyArray.N
    provides LazyArray.Valid, LazyArray.Get, LazyArray.Update

ghost function Upto(k: nat): set<int>
  ensures forall i :: i in Upto(k) <==> 0 <= i < k
  ensures |Upto(k)| == k
{
  if k == 0 then {} else Upto(k - 1) + {k - 1}
}

lemma SetCardinalities(u: set<int>, U: set<int>, x: int)
  requires u <= U
  ensures |u| <= |U|
  ensures x !in u && x in U ==> |u| < |U|
{
  if u == {} {
  } else {
    var y :| y in u;
    SetCardinalities(u - {y}, U - {y}, x);
  }
}

class LazyArray<T(0)> {
  ghost var Elements: seq<T>
  ghost const N: nat
  ghost const Repr: set<object>
  ghost var s: set<int>
  const default: T
  const a: array<T>
  const b: array<int>
  const c: array<int>
  var n: int

  predicate IsInitialized(i: int)
    requires 0 <= i < |Elements| == b.Length == c.Length
    requires 0 <= n <= |Elements|
    reads this, b, c
  {
    0 <= b[i] < n && c[b[i]] == i
  }

  ghost predicate Valid()
    reads this, Repr
    ensures Valid() ==> this in Repr && N == |Elements|
  {
    this in Repr &&
    a in Repr && b in Repr && c in Repr &&
    a != b && b != c && c != a &&
    N == |Elements| == a.Length == b.Length == c.Length &&
    0 <= n <= N &&
    (forall i :: 0 <= i < N ==>
      Elements[i] == if IsInitialized(i) then a[i] else default) &&
    s == (set i | 0 <= i < N && IsInitialized(i)) &&
    n == |s|
  }
  constructor (length: nat, initial: T)
    ensures Valid() && fresh(Repr)
    ensures |Elements| == length
    ensures forall i :: 0 <= i < |Elements| ==>
      Elements[i] == initial
  {
    N := length;
    Elements := seq(length, _ => initial);
    default := initial;
    a,b,c := new T[length], new int[length], new int[length];
    n := 0;
    Repr := {this, a, b, c};
    s,n := {},0;
  }
  function Get(i: int): T
    requires Valid() && 0 <= i < |Elements|
    reads Repr
    ensures Get(i) == Elements[i]
  {
    if IsInitialized(i) then a[i] else default
  }
  lemma ThereIsRoom(i: nat)
    requires Valid() && 0 <= i < N && !IsInitialized(i)
    ensures n < N
  {
    var S := Upto(N);
    SetCardinalities(s, S, i);
  }
  method Update(i: int, x: T)
    requires Valid() && 0 <= i < |Elements|
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
    ensures Elements == old(Elements)[i := x]
  {
    if !IsInitialized(i) {
        ThereIsRoom(i);
        b[i],c[n] := n,i;
        s, n := s + {i}, n + 1;
    }
    a[i]:=x;
    Elements := Elements[i:=x];
  }
}
}

import LA = LazyArraym
method LazyArrayTestHarness() {
  var a := new LA.LazyArray(300, 4);
  assert a.Get(100) == a.Get(101) == 4;
  a.Update(100, 9);
  a.Update(102, 1);
  assert a.Get(100) == 9 && a.Get(101) == 4 && a.Get(102) == 1;
 
  var b := new LA.LazyArray(200, 7);
  assert a.Get(100) == 9 && b.Get(100) == 7;
  a.Update(100, 2);
  assert a.Get(100) == 2 && b.Get(100) == 7;
}
