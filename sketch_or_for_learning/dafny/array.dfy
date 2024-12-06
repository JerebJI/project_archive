method LinearSearch0<T>(a: array<T>, P: T -> bool) returns (n: int)
ensures 0 <= n <= a.Length
ensures n == a.Length || P(a[n])
//ensures n==a.Length ==>
//  forall i :: 0 <= i < a.Length ==> !P(a[i])
ensures forall i :: 0 <= i < n ==> !P(a[i])
{
    n:=0;
    while n!=a.Length
      invariant 0<=n<=a.Length
      invariant forall i :: 0 <= i < n ==> !P(a[i])
      {
        if P(a[n]) {
            return;
        }
        assert forall i :: 0<=i<n ==> !P(a[i]) && !P(a[n]);
        assert forall i :: 0<=i<n ==> !P(a[i]) && forall i :: i==n ==> !P(a[i]);
        assert forall i :: 0<=i<n || i==n ==> !P(a[i]);
        assert forall i :: 0 <= i < n+1 ==> !P(a[i]);
        n := n+1;
        assert forall i :: 0 <= i < n ==> !P(a[i]);
      }
}

method Contains(a: array<int>, key: int) returns (present: bool)
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
ensures present == exists i :: 0 <= i < a.Length && key == a[i]
{
    var n := BinarySearch(a, key);
    present := n < a.Length && a[n] == key;
}

method BinarySearch(a: array<int>, key: int) returns (n: int)
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
ensures 0 <= n <= a.Length
ensures forall i :: 0 <= i < n ==> a[i] < key
ensures forall i :: n <= i < a.Length ==> key <= a[i]
{
    var lo, hi := 0, a.Length;
    while lo<hi
      invariant 0<=lo<=hi<=a.Length
      invariant forall i :: 0<=i<lo ==> a[i]<key
      invariant forall i :: hi<=i<a.Length ==> key<=a[i]
      {
        var mid := (lo+hi)/2;
        calc {
            lo;
            ==
            (lo+lo)/2;
            <= {assert lo<=hi;}
            (lo+hi)/2;
            < {assert lo<hi;}
            (hi+hi)/2;
            ==
            hi;
        }
        if a[mid]<key {
            lo := mid+1;
        } else {
            hi := mid;
        }
      }
    assert hi==lo;
    n := lo;
}

method BinarySearch1(a: array<int>, key: int) returns (n: int)
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
ensures -1 <= n < a.Length
ensures forall i :: 0 <= i < n ==> a[i] <= key
ensures forall i :: n < i < a.Length ==> key < a[i]
{
    var lo, hi := -1, a.Length-1;
    while lo<hi
      invariant -1<=lo<=hi<a.Length
      invariant forall i :: 0<=i<=lo ==> a[i]<=key
      invariant forall i :: hi<i<a.Length ==> key<a[i]
      {
        var mid := (lo+hi+1)/2;
        assert mid!=-1;
        if a[mid]<=key {
            lo := mid;
        } else {
            hi := mid-1;
        }
      }
    assert hi==lo;
    n := lo;
}

method Bslip(a: array<int>, key: int) returns (n: int)
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
ensures 0 <= n <= a.Length
ensures forall i :: n<=i<a.Length ==> a[i]>key
ensures forall i :: 0<=i<n ==> a[i]<=key
ensures 0<n<a.Length ==> a[n-1]<=key
//ensures forall m :: 0<=m<n ==> (exists i :: m<=i<a.Length ==> a[i]==key)
{
  var lo, hi := -1, a.Length-1;
  while lo<hi
    invariant -1<=lo<=hi<a.Length
    invariant forall i :: 0<=i<=lo ==> a[i]<=key
    invariant forall i :: hi<i<a.Length ==> key<a[i]
    {
      var mid := (lo+hi+1)/2;
      assert mid!=-1;
      if a[mid]<=key {
          lo := mid;
      } else {
          hi := mid-1;
      }
    }
  assert hi==lo;
  n:=hi+1;
  assert forall i :: n<=i<a.Length ==> a[i]>key;
  assert 0<n<a.Length ==> a[n-1]<=key;
  assert n>0 ==> a[n-1]<=key;
}

method BinarySearch2(a: array<int>, key: int) returns (n: int)
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
ensures -1 <= n <= a.Length
ensures (exists i :: 0<=i<a.Length && a[i]==key) && 0<=n<a.Length ==> a[n]==key
ensures n==-1 <== forall i :: 0<=i<a.Length ==> a[i]!=key
{
    var lo, hi := 0, a.Length;
    while lo<hi && (hi<a.Length ==> a[hi]==key)
      invariant 0<=lo<=hi<=a.Length
      invariant forall i :: 0<=i<lo ==> a[i]<key
      invariant forall i :: hi<=i<a.Length ==> key<=a[i]
      {
        var mid := (lo+hi)/2;
        if a[mid]<key {
            lo := mid+1;
        } else {
            hi := mid;
        }
      }
    if {
      case hi<a.Length && a[hi]==key => n:=hi;
      case true =>  n:=-1;
    }
}
/*
method BinarySearch3(a: array<int>, key: int) returns (n: int)
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
ensures -1 <= n <= a.Length
ensures  (exists i :: 0<=i<a.Length && a[i]==key) ==> 0<=n<a.Length && a[n]==key 
ensures !(exists i :: 0<=i<a.Length && a[i]==key) ==> n==-1
{
    var lo, hi := 0, a.Length;
    n:=-1;
    if a.Length==0 {
      n:=-1;
      return;
    }
    if a[0]==key {
      n:=0;
      return;
    }
    if a.Length==1 && a[0]!=key {
      n:=-1;
      return;
    }
    assert forall i :: 0<=i<lo ==> a[i]<key;
    assert (forall i :: hi<=i<a.Length ==> key<a[i]);
    assert forall i :: 0<=i<=0 ==> a[i]!=key;
    assert forall i :: 0<=i<=lo ==> a[i]!=key;
    while lo+1<hi
      invariant 0<=lo<=hi<=a.Length
      invariant forall i :: 0<=i<lo ==> a[i]!=key
      invariant forall i :: hi<i<a.Length==> a[i]!=key
      {
        var mid := (lo+hi)/2;
        if {
          case a[mid]<key => lo:=mid+1;
          case a[mid]>key => hi:=mid-1;
          case a[mid]==key => n:=mid; return;
        }
      }
}
*/

lemma MultisetIntersectionPrefix(a : array<int>, b:array<int>, m:nat, n:nat)
requires m<a.Length && n<b.Length
requires a[m]==b[n]
ensures multiset(a[m..])*multiset(b[n..])
     == multiset{a[m]} + (multiset(a[m+1..]) * multiset(b[n+1..]))
{
  var E := multiset{a[m]};
  calc {
    multiset(a[m..])*multiset(b[n..]);
    == {assert a[m..]==[a[m]]+a[m+1..];
        assert b[n..]==[b[n]]+b[n+1..];}
    (E+multiset(a[m+1..])) * (E+multiset(b[n+1..]));
    E + (multiset(a[m+1..]) * multiset(b[n+1..]));
  }
}

lemma MultisetIntersectionAdvance(a: array<int>, m:nat, B:multiset<int>)
requires m<a.Length && a[m] !in B
ensures multiset(a[m..])*B == multiset(a[m+1..])*B
     && B*multiset(a[m..]) == B*multiset(a[m+1..])
{
  var E := multiset{a[m]};
  calc {
    multiset(a[m..])*B;
    == {assert a[m..]==[a[m]]+a[m+1..];}
    (E + multiset(a[m+1..])) * B;
    (E*B) + (multiset(a[m+1..])*B);
    multiset{} + (multiset(a[m+1..])*B);
    (multiset(a[m+1..])*B);
  }
}

method CoincidenceCount(a: array<int>, b: array<int>) returns (c: nat)
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
requires forall i, j :: 0 <= i < j < b.Length ==> b[i] <= b[j]
ensures c == |multiset(a[..]) * multiset(b[..])|
{
  c:=0;
  var m,n := 0,0;
  while m<a.Length && n<b.Length
    invariant 0<=m<=a.Length && 0<=n<=b.Length
    invariant c + |multiset(a[m..]) * multiset(b[n..])|
               == |multiset(a[..])  * multiset(b[..])|
    decreases a.Length - m + b.Length - n
  {
    if {
      case a[m]==b[n] =>
      MultisetIntersectionPrefix(a,b,m,n);
      c,m,n := c+1,m+1,n+1;
      case a[m]<b[n] =>
      MultisetIntersectionAdvance(a,m,multiset(b[n..]));
      m:=m+1;
      case b[n]<a[m] =>
      MultisetIntersectionAdvance(b,n,multiset(a[m..]));
      n:=n+1;
      assert c + |multiset(a[m..]) * multiset(b[n..])|
            == |multiset(a[..])  * multiset(b[..])|;
    }
  }
}

method SlopeSearch(a: array2<int>, key: int) returns (m: int, n: int)
requires forall i, j, j' ::
   0<=i<a.Length0 && 0<=j<j'<a.Length1 ==> a[i,j]<=a[i,j']
requires forall i, i', j ::
   0<=i<i'<a.Length0 && 0<=j<a.Length1 ==> a[i,j]<=a[i',j]
requires exists i, j ::
   0<=i<a.Length0 && 0<=j<a.Length1 && a[i,j]==key
ensures 0 <= m < a.Length0 && 0 <= n < a.Length1
ensures a[m,n] == key
{
  m,n := 0, a.Length1-1;
  while a[m,n]!=key
    invariant 0<=m<a.Length0 && 0<=n<a.Length1
    invariant exists i, j ::
      m<=i<a.Length0 && 0<=j<=n && a[i,j]==key
    decreases a.Length0 - m + n
  {
    if a[m,n]<key {
      m := m+1;
    } else {
      n := n-1;
    }
  }
}

function Dist(x: int, y: int): nat {
  if x < y then y - x else x - y
}

method CanyonSearch(a: array<int>, b: array<int>) returns (d: nat)
requires a.Length != 0 && b.Length != 0
requires forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
requires forall i, j :: 0 <= i < j < b.Length ==> b[i] <= b[j]
ensures exists i, j ::
   0<=i<a.Length && 0<=j<b.Length && d==Dist(a[i], b[j])
ensures
   forall i,j :: 0<=i<a.Length && 0<=j<b.Length ==> d<=Dist(a[i], b[j])
{
  var m,n := 0,0;
  d := Dist(a[0],b[0]);
  while m<a.Length && n<b.Length
    invariant 0<=m<=a.Length && 0<=n<=b.Length
    invariant exists i, j ::
      0<=i<a.Length && 0<=j<b.Length && d==Dist(a[i], b[j])
    invariant
      forall i,j :: 0<=i<a.Length && 0<=j<b.Length ==>
        d<=Dist(a[i], b[j]) || (m<=i && n<=j)
    decreases a.Length-m + b.Length-n
  {
    d := if Dist(b[n], a[m]) < d then Dist(b[n], a[m]) else d;
    if {
      case a[m]<=b[n] => m:=m+1;
      case b[n]<=a[m] => n:=n+1;
    }
  }
}

method CanyonSearch3(a:array<int>, b:array<int>, c:array<int>) returns (d: nat)
requires a.Length!=0 && b.Length!=0 && c.Length!=0
requires forall i,j :: 0<=i<j<a.Length ==> a[i]<=a[j]
requires forall i,j :: 0<=i<j<b.Length ==> b[i]<=b[j]
requires forall i,j :: 0<=i<j<c.Length ==> c[i]<=c[j]
ensures exists i,j,k ::
   0<=i<a.Length && 0<=j<b.Length && 0<=k<c.Length
   && d==Dist(a[i],b[j])+Dist(b[j],c[k])+Dist(c[k],a[i])
ensures
   forall i,j,k ::
   0<=i<a.Length && 0<=j<b.Length && 0<=k<c.Length ==>
   d<=Dist(a[i],b[j])+Dist(b[j],c[k])+Dist(c[k],a[i])
{
  var m,n,l := 0,0,0;
  d := Dist(a[0],b[0])+Dist(b[0],c[0])+Dist(c[0],a[0]);
  while m<a.Length && n<b.Length && l<c.Length
    invariant 0<=m<=a.Length && 0<=n<=b.Length && 0<=l<=c.Length
    invariant exists i,j,k ::
      0<=i<a.Length && 0<=j<b.Length && 0<=k<c.Length
      && d==Dist(a[i],b[j])+Dist(b[j],c[k])+Dist(c[k],a[i])
    invariant forall i,j,k ::
      0<=i<a.Length && 0<=j<b.Length && 0<=k<c.Length ==>
      d<=Dist(a[i],b[j])+Dist(b[j],c[k])+Dist(c[k],a[i])
      || (m<=i && n<=j && l<=k)
    decreases a.Length-m + b.Length-n + c.Length-l
  {
    d := if Dist(a[m],b[n])+Dist(b[n],c[l])+Dist(c[l],a[m]) < d
         then Dist(a[m],b[n])+Dist(b[n],c[l])+Dist(c[l],a[m]) 
         else d;
    if {
      case a[m]<=b[n] && a[m]<=c[l] => m:=m+1;
      case b[n]<=a[m] && b[n]<=c[l] => n:=n+1;
      case c[l]<=a[m] && c[l]<=b[n] => l:=l+1;
    }
  }
}

function Count<T(==)>(a: seq<T>, lo: int, hi: int, x: T): nat
requires 0 <= lo <= hi <= |a|
{
if lo==hi then
0
else
Count(a, lo, hi-1, x) + (if a[hi-1]==x then 1 else 0)
}

lemma {:induction false} SplitCount<T>(a: seq<T>, lo: int, mid: int, hi: int, x: T)
requires 0 <= lo <= mid <= hi <= |a|
ensures Count(a, lo, mid, x) + Count(a, mid, hi, x)
       == Count(a, lo, hi, x)
{
  if mid<hi {
    calc {
      Count(a, lo, hi, x);
      if lo==hi then 0 else Count(a, lo, hi-1, x) + (if a[hi-1]==x then 1 else 0);
      == {SplitCount(a,lo,mid,hi-1,x);}
      if lo==hi then 0 else Count(a, lo, mid, x) + Count(a,mid,hi-1,x) + (if a[hi-1]==x then 1 else 0);
    }
  }
}

lemma DistinctCounts<T>(a: seq<T>, lo: int, hi: int, x: T, y: T)
requires 0 <= lo <= hi <= |a|
ensures x!=y ==> Count(a, lo, hi, x) + Count(a, lo, hi, y) <= hi-lo
{}

predicate HasMajority<T(==)>(a: seq<T>, lo: int, hi: int, x: T)
requires 0 <= lo <= hi <= |a|
{
  hi - lo < 2 * Count(a, lo, hi, x)
}

method FindWinner<Candidate(==)>(a: seq<Candidate>, ghost K: Candidate)
returns (k: Candidate)
requires HasMajority(a, 0, |a|, K)
ensures k == K
{
  k := a[0];
  var lo, hi, c := 0, 1, 1;
  while hi < |a|
    invariant 0 <= lo <= hi <= |a|
    invariant c == Count(a, lo, hi, k)
    invariant HasMajority(a, lo, hi, k)
    invariant HasMajority(a, lo, |a|, K)
  {
    if a[hi]==k {
      hi,c := hi+1, c+1;
    } else if hi+1-lo<2*c {
      hi := hi+1;
    } else {
      hi := hi+1;
      calc {
        true;
        ==>
        2 * Count(a, lo, hi, k) == hi - lo;
        ==> { DistinctCounts(a, lo, hi, k, K); }
        2 * Count(a, lo, hi, K) <= hi - lo;
        ==> { SplitCount(a, lo, hi, |a|, K); }
        |a| - hi < 2 * Count(a, hi, |a|, K);
        == // def. HasMajority
        HasMajority(a, hi, |a|, K);
      }
      k, lo, hi, c := a[hi], hi, hi + 1, 1;
    }
  }
  DistinctCounts(a, lo, |a|, k, K);
}

method SearchForWinner<Candidate(==)>(a: seq<Candidate>,
                                 ghost hasWinner: bool,
                                 ghost K: Candidate)
  returns (k: Candidate)
 requires |a| != 0
 requires hasWinner ==> HasMajority(a, 0, |a|, K)
 ensures hasWinner ==> k == K
{
 k := a[0];
 var lo, hi, c := 0, 1, 1;
 while hi < |a|
  invariant 0 <= lo <= hi <= |a|
  invariant c == Count(a, lo, hi, k)
  invariant HasMajority(a, lo, hi, k)
  invariant hasWinner ==> HasMajority(a, lo, |a|, K)
 {
  if a[hi] == k {
   hi, c := hi + 1, c + 1;
  } else if hi + 1 - lo < 2 * c { 
      hi := hi + 1;
  } else {
   hi := hi + 1;
   DistinctCounts(a, lo, hi, k, K);
   SplitCount(a, lo, hi, |a|, K);
   if hi == |a| {
    return;
   }
   k, lo, hi, c := a[hi], hi, hi + 1, 1;
  }
 }
 DistinctCounts(a, lo, |a|, k, K);
}

datatype Result<Candidate> = NoWinner | Winner(Candidate)
/*
method DetermineElection<Candidate(==)>(a: seq<Candidate>)
  returns (result: Result<Candidate>)
 ensures match result
  case Winner(c) => HasMajority(a, 0, |a|, c)
  case NoWinner => !exists c :: HasMajority(a, 0, |a|, c)
{
  if |a| == 0 {
    return NoWinner;
  }
  ghost var hasWinner := exists c :: HasMajority(a, 0, |a|, c);
  assert hasWinner==exists c :: HasMajority(a, 0, |a|, c);
  ghost var w;
  if hasWinner {
   w :| HasMajority(a, 0, |a|, w);
  } else {
   w := a[0];
  }
  assert hasWinner==exists c :: HasMajority(a, 0, |a|, c);
  var c := SearchForWinner(a, hasWinner, w);
  assert hasWinner==exists c :: HasMajority(a, 0, |a|, c);
  if HasMajority(a, 0, |a|, c) {
    result := Winner(c);
  } else {
    assert hasWinner==exists c :: HasMajority(a, 0, |a|, c);
    assert hasWinner==false;
    calc {
      //hasWinner==false;
      (exists c :: HasMajority(a, 0, |a|, c))==false;
      !exists c :: HasMajority(a, 0, |a|, c);
    }
    result := NoWinner;
    assert !exists c :: HasMajority(a, 0, |a|, c);
  }
}
*/

method Main() {
  var a := new int[5];
  a[0],a[1],a[2],a[3],a[4] := 1,2,3,3,6;
  var r := BinarySearch(a,3);
  print(r);
}