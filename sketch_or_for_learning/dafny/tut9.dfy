function fib(n: nat): nat
{
  if n == 0 then 0
  else if n == 1 then 1
  else fib(n - 1) + fib(n - 2)
}
method ComputeFib(n: nat) returns (b: nat)
  ensures b == fib(n)
{
  var i: int := 0;
  var a := 1;
  b := 0;
  while i < n
    invariant 0<=i<=n
    invariant b==fib(i)
    invariant i==0 ==> a==1
    invariant i>0  ==> a==fib(i-1)
  {
    a, b := b, a + b;
    i := i + 1;
  }
}
