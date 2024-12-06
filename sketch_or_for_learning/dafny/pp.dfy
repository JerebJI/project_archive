function F(x: int): int 
decreases x
{

 if x < 10 then x else F(x - 1)

}

function G(x: int): int 
decreases x
{

 if 0 <= x then G(x - 2) else x

}

function H(x: int): int 
decreases x+60
{

 if x < -60 then x else H(x - 1)

}

function I(x: nat, y: nat): int 
decreases x+y
{

 if x == 0 || y == 0 then

  12

 else if x % 2 == y % 2 then

  I(x - 1, y)

 else

  I(x, y - 1)

}

function J(x: nat, y: nat): int 
decreases x*4+y
{

 if x == 0 then

  y

 else if y == 0 then

  J(x - 1, 3)

 else

  J(x, y - 1)

}

function K(x: nat, y: nat, z: nat): int 
decreases x+y
{

  if x < 10 || y < 5 then

    x + y

  else if z == 0 then

    K(x - 1, y, 5)

  else

    K(x, y - 1, z - 1)

}

function L(x: int): int 
decreases 100-x
{
if x < 100 then L(x + 1) + 10 else x

}

function M(x: int, b: bool): int 
decreases !b
{

 if b then x else M(x + 25, true)

}

function N(x: int, y: int, b: bool): int 
decreases x,b
{

  if x <= 0 || y <= 0 then

    x + y

  else if b then

    N(x, y + 3, !b)

  else

    N(x - 1, y, true)

}

method RequiredStudyTime(c: nat) returns (hours: nat)
ensures hours <= 200

method Outer(a: nat) 
decreases a
{

   if a != 0 {

      var b := RequiredStudyTime(a - 1);

      Inner(a, b);

   }

}

method Inner(a: nat, b: nat)
decreases a,b
   requires 1 <= a

{

   if b == 0 {

      Outer(a - 1);

   } else {

      Inner(a, b - 1);

   }

}

method Outer1(a: nat)
decreases a,-1
{

   if a != 0 {

      var b := RequiredStudyTime(a - 1);

      Inner1(a - 1, b);

   }

}

 

method Inner1(a: nat, b: nat) 
decreases a,b
{

   if b == 0 {

      Outer1(a);

   } else {

      Inner1(a, b - 1);

   }

}

function F1(n: nat): nat 
decreases n,1
{

   if n == 0 then 1 else n - M1(F1(n - 1))

}

function M1(n: nat): nat 
decreases n,0
{

   if n == 0 then 0 else n - F1(M1(n - 1))

}

function F2(x: nat, y: nat): int
{

   if 1000 <= x then

      x + y

   else if x % 2 == 0 then

      F2(x + 2, y + 1)

   else if x < 6 then

      F2(2 * y, y)

   else

      F2(x - 4, y + 3)

}

function More(x: int): int {

   if x <= 0 then 1 else More(x - 2) + 3

}

lemma {:induction false} Increasing(x: int)
ensures x < More(x)
{
  assert true;
  if x<=0 {
    assert x<=0;
    assert x<=0 && More(x)==1;
    assert x<More(x);
  } else {
    assert x>0;
    assert x>0 && More(x)==More(x-2)+3;
    Increasing(x-2);
    assert 0<x && More(x)==More(x-2)+3 && x-2<More(x-2);
    assert More(x)==More(x-2)+3 && x+1<More(x-2)+3;
    assert x+1<More(x);
    assert x<More(x);
  }
  assert x<More(x);
}

lemma {:induction false} Increasing1(x: int)

   ensures x < More(x)

{

   if x <= 0 {

      assert More(x) == 1; // def. More for x <= 0

   } else {

      assert More(x) == More(x - 2) + 3; // def. More for 0 < x

      Increasing1(x - 2); // induction hypothesis

      assert x - 2 < More(x - 2); // what we get from the recursive call

      assert x + 1 < More(x - 2) + 3; // add 3 to each side

      assert x + 1 < More(x); // previous line and def. More above

   }

}

method ExampleLemmaUse(a: int) {

   var b := More(a);
   Increasing(a);
   Increasing(b);
   b := More(b);
   assert 2 <= b - a;

}

lemma tst(x:int,y:int) 
ensures 5*x-3*(y+x)==2*x-3*y
{
  calc {
    5*x-3*(y+x);
    ==
    5*x-3*y-3*x;
    ==
    2*x-3*y;
  }
}

function Reduce(m: nat, x: int): int {

   if m == 0 then x else Reduce(m / 2, x + 1) - m

}

lemma {:induction false} ReduceUpperBound(m: nat, x: int)

   ensures Reduce(m, x) <= x

{
  if m==0 {
  } else {
    calc {
      Reduce(m,x);
      ==
      Reduce(m/2,x+1)-m;
      <= {ReduceUpperBound(m/2,x+1);
      assert Reduce(m/2,x+1)<=x+1;}
      x+1-m;
    }
  }
}

lemma {:induction false} ReduceLowerBound(m: nat, x: int)

   ensures x - 2 * m <= Reduce(m, x)

{

   if m == 0 {
   } else {
    calc {
      Reduce(m,x);
      ==
      Reduce(m/2,x+1)-m;
      >= {ReduceLowerBound(m/2,x+1);
      assert x+1-2*(m/2)<=Reduce(m/2,x+1);}
      x+1-m-m;
      >
      x-2*m;
    }
   }
}

function Mult(x: nat, y: nat): nat {

   if y == 0 then 0 else x + Mult(x, y - 1)

}

lemma {:induction false} MultCommutative(x: nat, y: nat)
   ensures Mult(x, y) == Mult(y, x)
{
  if x==y {

  } else if x==0 {
    MultCommutative(x,y-1);
  } else if y<x {
    MultCommutative(y,x);
  } else {
    calc {
      Mult(x,y);
      ==
      x+Mult(x,y-1);
      == {MultCommutative(x,y-1);}
      x+Mult(y-1,x);
      ==
      x+y-1+Mult(y-1,x-1);
      == {MultCommutative(x-1,y-1);}
      x+y-1+Mult(x-1,y-1);
      ==
      y+Mult(x-1,y);
      == {MultCommutative(x-1,y);}
      y+Mult(y,x-1);
      ==
      Mult(y,x);
    }
  }
}

lemma {:induction false} MultCommutative1(x: nat, y: nat)
   decreases x+y
   ensures Mult(x, y) == Mult(y, x)
{
  if x==y {
  } else if x==0 {
    MultCommutative1(x,y-1);
  } else if y==0 {
    MultCommutative1(x-1,y);
  } else {
    calc {
      Mult(x,y);
      ==
      x+Mult(x,y-1);
      == {MultCommutative1(x,y-1);}
      x+Mult(y-1,x);
      ==
      x+y-1+Mult(y-1,x-1);
      == {MultCommutative1(x-1,y-1);}
      x+y-1+Mult(x-1,y-1);
      ==
      y+Mult(x-1,y);
      == {MultCommutative1(x-1,y);}
      y+Mult(y,x-1);
      ==
      Mult(y,x);
    }

  }
}

datatype Tree<T> = Leaf(data: T)
                 | Nodet(left: Tree<T>, right: Tree<T>)

function Mirror<T>(t: Tree<T>): Tree<T> {
   match t
   case Leaf(_) => t
   case Nodet(left, right) => Nodet(Mirror(right), Mirror(left))
}

lemma {:induction false} MirrorMirror<T>(t: Tree<T>)
   ensures Mirror(Mirror(t)) == t
{
   match t
   case Leaf(_) =>
   case Nodet(left, right) =>
   calc {
    Mirror(Mirror(Nodet(left,right)));
    Mirror(Nodet(Mirror(right),Mirror(left)));
    Nodet(Mirror(Mirror(left)),Mirror(Mirror(right)));
    == {MirrorMirror(left);MirrorMirror(right);}
    Nodet(left,right);
   }
}

function Size<T>(t: Tree<T>): nat {
   match t
   case Leaf(_) => 1
   case Nodet(left, right) => Size(left) + Size(right)
}

lemma {:induction false} MirrorSize<T>(t: Tree<T>)
   ensures Size(Mirror(t))==Size(t)
{
  match t
  case Leaf(_)=>
  case Nodet(left,right) =>
  calc {
    Size(Mirror(Nodet(left, right)));
    Size(Nodet(Mirror(right),Mirror(left)));
    Size(Mirror(right))+Size(Mirror(left));
    == {MirrorSize(right);MirrorSize(left);}
    Size(right)+Size(left);
    Size(Nodet(left,right));
  }
}

datatype List<T> = Nil | Cons(head: T, tail: List<T>)
datatype Op = Add | Mul
datatype Expr = Const(nat)
              | Var(string)
              | Node(op: Op, args: List<Expr>)

function Substitute(e: Expr, n: string, c: nat): Expr
{
  match e
  case Const(_) => e
  case Var(s) => if s == n then Const(c) else e
  case Node(op, args) => Node(op, SubstituteList(args, n, c))
}

function SubstituteList(es: List<Expr>, n: string, c: nat): List<Expr>
{
  match es
  case Nil => Nil
  case Cons(e, tail) =>
    Cons(Substitute(e, n, c), SubstituteList(tail, n, c))
}

function Eval(e: Expr, env: map<string, nat>): nat {

  match e

  case Const(c) => c

  case Var(s) => if s in env.Keys then env[s] else 0

  case Node(op, args) => EvalList(args, op, env)

}

 

function EvalList(args: List<Expr>, op: Op,
                  env: map<string, nat>): nat

{
match args

  case Nil =>

    (match op case Add => 0 case Mul => 1)

  case Cons(e, tail) =>

    var v0, v1 := Eval(e, env), EvalList(tail, op, env);

    match op

    case Add => v0 + v1

    case Mul => v0 * v1

}


lemma EvalSubstitute(e: Expr, n: string, c: nat, env: map<string, nat>)
  ensures Eval(Substitute(e, n, c), env) == Eval(e, env[n := c])
{

  match e

  case Const(_) =>

  case Var(_) =>

  case Node(op, args) =>

    EvalSubstituteList(args, op, n, c, env);

}

lemma {:induction false} EvalSubstituteList(

    args: List<Expr>, op: Op, n: string, c: nat, env: map<string, nat>)

  ensures EvalList(SubstituteList(args, n, c), op, env)

       == EvalList(args, op, env[n := c])

{

  match args

  case Nil =>

  case Cons(e, tail) =>
 EvalSubstitute(e, n, c, env);

    EvalSubstituteList(tail, op, n, c, env);

}

function Unit(op: Op): nat {

  match op case Add => 0 case Mul => 1

}

function Optimize(e: Expr): Expr {

  if e.Node? then

    var args := OptimizeAndFilter(e.args, Unit(e.op));

    Shorten(e.op, args)
else

    e // no change

}

function Shorten(op: Op, args: List<Expr>): Expr {

  match args

  case Nil => Const(Unit(op))

  case Cons(e, Nil) => e

  case _ => Node(op, args)

}

function OptimizeAndFilter(es: List<Expr>, unit: nat): List<Expr>

{

  match es

  case Nil => Nil

  case Cons(e, tail) =>

    var e', tail' := Optimize(e), OptimizeAndFilter(tail, unit);

    if e' == Const(unit) then tail' else Cons(e', tail')

}


