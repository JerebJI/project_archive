method dokaz_17(p:bool,q:bool,s:bool,r:bool)
requires p ==> q
requires p || s
requires !s && !r
{
    assert !s;
    assert p;
    assert q;
    assert !r;
    assert q && !r;
}