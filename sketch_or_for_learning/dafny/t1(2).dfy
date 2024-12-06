function N(x: int, y: int, b: bool): int 
{
 if x <= 0 || y <= 0 then
  x + y
 else if b then
  N(x, y + 3, !b)
 else
  N(x - 1, y, true)

}