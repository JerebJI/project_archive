method Triple(x: int) returns (r: int)
    requires x == 2
    ensures r == 3*x
{
    var y := x/2;
    r:=6*y;
}

method Main() {
    var t := Triple(2);
    var j := 10;
    while (t<j)
        invariant j>=t
    {
        t:=t+1;
    }
    assert t<100;
}
