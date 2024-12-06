lemma MaxExists(a:seq<int>)
ensures exists m :: 0<=m<|a| && forall i :: 0<=i<|a| ==> a[i]<=a[m]

method max(a:array<int>) returns (x:int)
requires a.Length>0
ensures 0<=x<a.Length
ensures forall i :: 0<=i<a.Length ==> a[i]<=a[x]
{
    x := 0;
    var y := a.Length-1;
    calc { // originalna invarianta  --> problem so dvojni kvantifikatorji, problem je dokazati vstop v zanko 
        exists m :: x<=m<=y && forall i :: ((0<=i<x || y<i) && 0<=i<a.Length) ==> a[i]<=a[m];
    }
    while (x!=y)
    invariant x<=y
    invariant 0<=x<a.Length
    invariant 0<=y<a.Length
    invariant forall i :: 0<=i<a.Length && a[i]>a[x] && a[i]>a[y] ==> x<=i<=y // kopirana iz rešitev
    {
        if (a[x]<=a[y]) {
            x:=x+1;
        } else {
            y:=y-1;
        }
    }
}