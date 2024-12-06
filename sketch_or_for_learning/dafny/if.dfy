function More(x: int): int {

   if x <= 0 then 1 else More(x - 2) + 3

}

method F1(a: int) returns (x:int)
ensures x!=1
{
    x := a;
    assert x>=1 || x<=1;
    if {
        case x>=1 =>
           assert x>=1;
           x:=x+1;
           assert x!=1;
        case x<=1 =>
           assert x<=1;
           x:=x-1;
           assert x!=1;
    }
}

method F2(a:int, b:int)
{
    assert true;
    var x,y := a,b;
    assert x>=y || y>=x;
    if {
        case x>=y =>
           assert x>=y;
        case x<=y =>
           assert x<=y;
           x,y := y,x;
           assert x>=y;
    }
    assert x>=y;
}

method F3(a:int, b:int) {
    assert true;
    var x,y:=a,b;
    x,y:=y*y,x*x;
    assert x>=0 && y>=0;
    if {
        case x>=y =>
           assert x>=y;
           assert x-y>=0;
           x:=x-y;
           assert x>=0;
        case y>=x =>
           assert y>=x;
           assert y-x>=0;
           y:=y-x;
           assert y>=0;
    }
    assert x>=0 && y>=0;
}

method F4(x:bool, y:bool) {
    var a,b := x,y;
    assert true;
    assert (!a||b) || (a||!b);
    if {
        case !a || b =>
           assert !a||b;
           a := !a;
           assert a||b;
        case a || !b =>
           assert a||!b;
           b := !b;
           assert a||b;
    }
    assert a || b;
}

