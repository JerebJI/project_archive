method Abs(x: int) returns (y: int)
  requires x+2==-x
  ensures 0 <= y
  ensures 0 <= x ==> y == x
  ensures x < 0 ==> y == -x
{
  y:= x + 2;
}
method Abs2(x: int) returns (y: int)
  requires x+1==-x
  ensures 0 <= y
  ensures 0 <= x ==> y == x
  ensures x < 0 ==> y == -x
{
  y:= x + 1;
}
method Testing()
{
  var v := Abs(-1);
}
