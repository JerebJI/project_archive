predicate IsSorted(a:seq<int>)
{
    forall i,j :: 0<=i<j<|a| ==> a[i]<=a[j]
}

method InsertionSort(a:array<int>)
modifies a
ensures IsSorted(a[..])
ensures multiset(a[..])==old(multiset(a[..]))
{
    var i := 0;
    while i!=a.Length
      decreases a.Length-i
      invariant 0<=i<=a.Length
      invariant IsSorted(a[..i])
      invariant multiset(a[..])==old(multiset(a[..]))
    {
        var j := i;
        while j>0 && a[j-1]>a[j]
          invariant 0<=i<a.Length
          invariant 0<=j<=i
          invariant multiset(a[..])==old(multiset(a[..]))
          invariant IsSorted(a[..j])
          invariant IsSorted(a[j..i+1])
          invariant forall n,m :: 0<=n<j && j<m<=i ==> a[n]<=a[m]
          invariant forall n :: j<n<=i && j>0 ==> a[j-1]<=a[n]
        {
            a[j-1],a[j] := a[j],a[j-1];
            j := j-1;
        }
        i := i+1;
    }
    assert a[..a.Length]==a[..];
}