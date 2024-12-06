function Abs(x:int) : nat
{
    if x>=0 then x else -x
}

method findClosestNumber(a : array<int>) returns (r:int)
requires a.Length>0
ensures forall i :: 0<=i<a.Length ==> Abs(r)<=Abs(a[i])
ensures exists i :: 0<=i<a.Length && r==a[i]
ensures forall i :: (0<=i<a.Length && Abs(a[i])==Abs(r)) ==> a[i]<=r
{
    var ind := 1;
    r:=a[0];
    while (ind<a.Length)
      invariant 0<=ind<=a.Length
      invariant forall i :: 0<=i<ind ==> Abs(r)<=Abs(a[i]) 
      invariant exists i :: 0<=i<ind && r==a[i]
      invariant forall i :: (0<=i<ind && Abs(a[i])==Abs(r)) ==> a[i]<=r
    {
        if || Abs(a[ind])<Abs(r)
           || (Abs(a[ind])==Abs(r) && a[ind]>r) 
        {
            r := a[ind];
        }
        ind := ind+1;
    }
}