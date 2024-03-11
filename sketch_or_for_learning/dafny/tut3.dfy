method Abs(x: int) returns (y: int)
  requires x<0
  ensures 0 <= y
  ensures 0 <= x ==> y == x
  ensures x < 0 ==> y == -x
{
   return -x;
}
