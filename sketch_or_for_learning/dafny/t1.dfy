function abs(x:int): int
{
   if x<0 then -x else x
}

function max(x:int,y:int): int
{
   if x>y then x else y
}

method Test(x:int)
{
   assert abs(x) == max(x,-x);
}
