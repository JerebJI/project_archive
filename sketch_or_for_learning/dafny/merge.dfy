lemma ArrayEqual(a:array)
ensures a[..]==a[..a.Length]
{}

predicate IsSorted(a:array<int>,l:nat,u:nat)
reads a
{
    forall i, j :: 0 <= l <= i < j < u <= a.Length ==> a[i] <= a[j]
} 

lemma ArrayIndexUnit(a:array)
ensures a[..] == a[..a.Length]
{}

predicate Below(a: seq<int>, b:seq<int>) {
    forall i,j :: 0<=i<|a| && 0<=j<|b| ==> a[i]<=b[j]
}

method {:rlimit 200000} {:timeLimitMultiplier 5} Merge(a: array<int>, b: array<int>) returns (c: array<int>)
requires IsSorted(a,0,a.Length) && IsSorted(b,0,b.Length)
ensures fresh(c) && c.Length==a.Length+b.Length
ensures IsSorted(c,0,c.Length)
ensures multiset(a[..])+multiset(b[..])==multiset(c[..])
{
    var i,j,k : nat := 0,0,0;
    c := new int[a.Length+b.Length];
    while k!=c.Length
      invariant k==i+j
      invariant 0<=i<=a.Length && 0<=j<=b.Length && 0<=k<=c.Length
      invariant fresh(c) && c.Length==a.Length+b.Length
      invariant IsSorted(c,0,k)
      invariant multiset(a[..i])+multiset(b[..j])==multiset(c[..k])
      invariant Below(c[..k],a[i..]) && Below(c[..k],b[j..])
    {
      if i==a.Length {
        assert {:split_here} true;
        c[k]:=b[j];
        j := j+1;
        assert {:split_here} true;
      } else if j==b.Length {
        assert {:split_here} true;
        c[k]:=a[i];
        i := i+1;
        assert {:split_here} true;
      } else {
        assert {:split_here} true;
        if a[i]<b[j] {
          c[k]:=a[i];
          i := i+1;
        } else {
          assume false;
          c[k]:=b[j];
          j := j+1;
        }
        assert {:split_here} true;
      }
      k := k+1;
    }
    ArrayIndexUnit(a); ArrayIndexUnit(b); ArrayIndexUnit(c);
}