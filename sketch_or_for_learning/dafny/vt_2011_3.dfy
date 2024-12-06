predicate IsDuplet<T(==)>(a:array<T>,x:T)
reads a
{
    exists ix1,ix2 ::
        && 0<=ix1<a.Length
        && 0<=ix2<a.Length
        && ix1!=ix2
        && a[ix1]==x
        && a[ix2]==x
}

method duplets<T(==)>(a:array<T>) returns (x:T,y:T)
requires a.Length>=4
requires exists gx,gy :: IsDuplet(a,gx) && IsDuplet(a,gy) && gx!=gy
ensures IsDuplet(a,x) && IsDuplet(a,y) && x!=y
{
    var ix1,ix2 := 0,1;
    x := a[ix1];
    while a[ix1]!=a[ix2] && ix1<a.Length-1
      invariant 0<=ix1<a.Length-1
      invariant 0<=ix2<a.Length
      invariant ix1<ix2
      invariant x==a[ix1]
      decreases (a.Length-ix1,a.Length-ix2)
    {
        if {
            case ix2<a.Length  => ix2:=ix2+1;
            case ix2==a.Length => ix1,ix2:=ix1+1,ix1+2;
        }
    }
    assert IsDuplet(a,x);
    var iy1 := ix1;
    assert IsDuplet(a,x);
    while a[iy1]==x
      invariant 0<=iy1<a.Length-1
      invariant IsDuplet(a,x)
    var iy2 := iy1+1;
    y := a[iy1];
    assert IsDuplet(a,x);
    while a[iy1]!=a[iy2]
      invariant 0<=iy1<a.Length
      invariant 0<=iy2<a.Length
      invariant iy1!=iy2
      invariant y==a[iy1]
      invariant x!=y
      invariant IsDuplet(a,x)
    assert IsDuplet(a,y);
    assert IsDuplet(a,x);
    assert x!=y;
}