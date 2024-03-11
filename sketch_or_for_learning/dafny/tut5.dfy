function max(a: int, b: int): int
{
  if a>b then a else b
}
method Testing(a:int,b:int) {
  assert a>=b ==> max(a,b)==a;
  assert a<b ==> max(a,b)==b;
}
