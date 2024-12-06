method SetEndPoints(a: array<int>, left: int, right: int)
 requires a.Length > 1
 ensures a[0] == left && a[a.Length - 1] == right
 modifies a
{
 a[0] := left;
 a[a.Length - 1] := right;
}

method Min(a: array<int>) returns (m: int)
 ensures forall i :: 0 <= i < a.Length ==> m <= a[i]
 modifies a
{
 m := 1330;
 var n := 0;
 while n != a.Length
  invariant 0 <= n <= a.Length
  invariant forall i :: 0 <= i < n ==> m <= a[i]
 {
  a[n] := 1330;
  n := n + 1;
 }
}

method Increment(a: array<int>, i: int)
requires 0 <= i < a.Length
modifies a
 ensures a[i] == old(a[i]) + 1 // common mistake
{
a[i] := a[i] + 1; // error: postcondition violation
}

method OldVsParameters(a: array<int>, i: int) returns (y: int)
 requires 0 <= i < a.Length
 modifies a
 ensures old(a[i] + y) == 25
 {
    y := 25-a[i];
 }

method IncrementArray(a: array<int>)
 modifies a
 ensures forall i :: 0 <= i < a.Length ==> a[i] == old(a[i]) + 1
{
 var n := 0;
 while n != a.Length
  invariant 0 <= n <= a.Length
  invariant forall i :: 0 <= i < n ==> a[i] == old(a[i]) + 1
  invariant forall i :: n <= i < a.Length ==> a[i] == old(a[i])
 {
  a[n] := a[n] + 1;
  n := n + 1;
 }
}

method CopyArray(src: array, dst: array)
  requires src.Length == dst.Length
  requires src != dst
  modifies dst
  ensures forall i :: 0 <= i < src.Length ==> dst[i] == src[i]
{
  var n := 0;
  while n != src.Length
    invariant 0 <= n <= src.Length
    invariant forall i :: 0 <= i < n ==> dst[i] == old(src[i])
    invariant forall i :: 0 <= i < src.Length ==> src[i] == old(src[i])
  {
    dst[n] := src[n];
    n := n + 1;
  }
}

method Reverse(a: array)
  modifies a
  ensures forall i :: 0<=i<a.Length ==> old(a[i])==a[a.Length-i-1]
{
  var n:=0;
  while n!=(a.Length+1)/2
    invariant 0<=n<=(a.Length+1)/2
    invariant forall i :: 0<=i<n || a.Length-n<=i<a.Length 
               ==> a[i]==old(a[a.Length-i-1])
    invariant forall i :: n<=i<a.Length-n ==> a[i] == old(a[i])
    {
      a[n],a[a.Length-n-1] := a[a.Length-n-1],a[n];
      n := n+1;
    }
}

method Transpose(a: array2)
  modifies a
  requires a.Length0==a.Length1
  ensures forall i,j :: 0<=i<a.Length0 && 0<=j<a.Length1 ==> old(a[i,j])==a[j,i]
{
  var n:=0;
  while n!=a.Length0
    invariant 0<=n<=a.Length0
    invariant forall i,j :: 0<=i<n && 0<=j<a.Length1 ==>
      old(a[i,j])==a[j,i] && old(a[j,i])==a[i,j]
    invariant forall i,j :: n<=i<a.Length0 && n<=j<a.Length1 ==> old(a[i,j])==a[i,j]
    {
      var m := n;
      while m!=a.Length1
        invariant n<=m<=a.Length1
        invariant forall i,j :: n<i<a.Length0 && n<j<a.Length1 ==>
          old(a[i,j])==a[i,j]
        invariant forall j :: m<=j<a.Length0 ==>
          old(a[n,j])==a[n,j] && old(a[j,n])==a[j,n]
        invariant forall i,j :: 0<=i<n && 0<=j<a.Length1 ==>
          old(a[i,j])==a[j,i] && old(a[j,i])==a[i,j]
        invariant forall j :: n<=j<m ==>
          old(a[n,j])==a[j,n] && old(a[j,n])==a[n,j]
      {
        a[m,n],a[n,m] := a[n,m],a[m,n];
        m := m+1;
      }
      n:=n+1;
    }
}

lemma PlusOneModulo(a:array,i:nat)
  requires 0<=i<a.Length
  ensures (i<a.Length-1  ==> a[(i+1)%a.Length]==a[i+1])
       && (i==a.Length-1 ==> a[(i+1)%a.Length]==a[0])
{}

method RotateLeft<T>(a: array<T>)
  modifies a
  ensures forall i :: 0<=i<a.Length ==>
    old(a[(i+1)%a.Length])==a[i]
{
  var n := 0;
  var f : T;
  if a.Length>0 {
    f := a[0];
  }
  while n<a.Length
    invariant 0<=n<=a.Length
    invariant forall i :: 0<=i<n ==>
      old(a[(i+1)%a.Length])==a[i]
    invariant forall i :: n<i<a.Length ==>
      old(a[i])==a[i]
  {
    PlusOneModulo(a,n);
    if n<a.Length-1 {
      a[n] := a[n+1];
    } else {
      a[n] := f;
    }
    n := n+1;
    assert forall i :: n<i<a.Length ==>
      old(a[i])==a[i];
  }
}

method Reverse1(a: array)
  modifies a
  ensures forall i :: 0<=i<a.Length ==> old(a[i])==a[a.Length-i-1]
{
  forall i | 0<=i<a.Length {
    a[i] := a[a.Length-i-1];
  }
}

method Transpose1(a: array2)
  modifies a
  requires a.Length0==a.Length1
  ensures forall i,j :: 0<=i<a.Length0 && 0<=j<a.Length1 ==> old(a[i,j])==a[j,i]
{
  forall i,j | 0<=i<a.Length0 && 0<=j<a.Length1 {
    a[i,j] := a[j,i];
  } 
}

method Main() {
  var a := new int[3,3];
  a[0,0],a[0,1],a[0,2],
  a[1,0],a[1,1],a[1,2],
  a[2,0],a[2,1],a[2,2] := 1,2,3,4,5,6,7,8,9;
  Transpose(a);
  print(a[0,0],a[0,1],a[0,2],
  a[1,0],a[1,1],a[1,2],
  a[2,0],a[2,1],a[2,2]);
}