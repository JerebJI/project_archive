datatype List<T> = Nil | Cons(head: T, tail: List<T>)

function Length<T>(xs: List<T>): nat {
    match xs
    case Nil => 0
    case Cons(_,t) => 1+Length(t)
}

function Snoc<T>(xs: List<T>,y:T):List<T> {
    match xs
    case Nil => Cons(y,Nil)
    case Cons(x,t) => Cons(x,Snoc(t,y))
}

lemma {:induction false} LengthSnoc<T>(xs: List<T>, x:T)
ensures Length(Snoc(xs,x))==Length(xs)+1
{
    match xs
    case Nil => 
    case Cons(y,t) =>
    calc {
        Length(Snoc(xs,x));
        Length(Cons(y,Snoc(t,x)));
        1+Length(Snoc(t,x));
        == {LengthSnoc(t,x);}
        1+1+Length(t);
        1+Length(Cons(y,t));
        1+Length(xs);
    }
}

function Append<T>(xs: List<T>, ys: List<T>): List<T> 
ensures Length(Append(xs, ys)) == Length(xs) + Length(ys)
{
   match xs
   case Nil => ys
   case Cons(x, tail) => Cons(x, Append(tail, ys))
}

lemma {:induction false} SnocApp<T>(xs:List<T>,y:T) 
ensures Snoc(xs, y) == Append(xs, Cons(y, Nil))
{
    match xs
    case Nil =>
    case Cons(x,t) =>
    calc {
        Append(xs,Cons(y,Nil));
        Cons(x,Append(t,Cons(y,Nil)));
        {SnocApp(t,y);}
        Cons(x,Snoc(t,y));
    }
}

lemma AppendDecomposition<T>(a: List<T>, b: List<T>,
                             c: List<T>, d: List<T>)
   requires Length(a) == Length(c)
   requires Append(a, b) == Append(c, d)
   ensures a == c && b == d
{}

function F(x: int, y: int): int
const L: int
const R: int

lemma {:axiom} LeftUnit(x: int)
   ensures F(L, x) == x

lemma {:axiom} RightUnit(x: int)
   ensures F(x, R) == x

lemma LeftRightUnit(x: int)
ensures L==R
{
    calc {
        L;
        == {RightUnit(L);}
        F(L,R);
        == {LeftUnit(R);}
        R;
    }
}

function At<T>(xs: List<T>, i: nat): T
   requires i < Length(xs)
{
   if i == 0 then xs.head else At(xs.tail, i - 1)
}

function Find<T(==)>(xs: List<T>, y: T): nat
   ensures Find(xs, y) <= Length(xs)
{
   match xs
   case Nil => 0
   case Cons(x, tail) =>
      if x == y then 0 else 1 + Find(tail, y)

}

ghost predicate Ordered(xs: List<int>) {
   match xs
   case Nil => true
   case Cons(x, Nil) => true
   case Cons(x, Cons(y, _)) => x <= y && Ordered(xs.tail)
}

lemma AllOrdered(xs: List<int>, i: nat, j: nat)
   requires Ordered(xs) && i <= j < Length(xs)
   ensures At(xs, i) <= At(xs, j)
{
    if i!=0 {
        AllOrdered(xs.tail,i-1,j-1);
    } else if i==j {
    } else {
        AllOrdered(xs.tail,0,j-1);
    }
}

ghost function Count(xs: List<int>, p: int): nat {
   match xs
   case Nil => 0
   case Cons(x, tail) =>
      (if x == p then 1 else 0) + Count(tail, p)
}

ghost function Project(xs: List<int>, p: int): List<int> {
   match xs
   case Nil => Nil
   case Cons(x, tail) =>
      if x == p then Cons(x, Project(tail, p)) else Project(tail, p)
}

function InsertionSort(xs: List<int>): List<int> {
   match xs
   case Nil => Nil
   case Cons(x, tail) => Insert(x, InsertionSort(tail))
}

function Insert(y: int, xs: List<int>): List<int> {
   match xs
   case Nil => Cons(y, Nil)
   case Cons(x, tail) =>
      if y < x then Cons(y, xs) else Cons(x, Insert(y, tail))
}

lemma InsertionSortOrdered(xs: List<int>) 
ensures Ordered(InsertionSort(xs))
{
    match xs
    case Nil =>
    case Cons(x,t) =>
    InsertOrdered(x,InsertionSort(t));
}

lemma InsertOrdered(y: int, xs: List<int>)
requires Ordered(xs)
ensures Ordered(Insert(y, xs))
{}

lemma InsertionSortSameElements(xs: List<int>, p: int)
   ensures Project(xs, p) == Project(InsertionSort(xs), p)
{
    match xs
    case Nil =>
    case Cons(x,t) =>
    InsertSameElements(x,InsertionSort(t),p);
}

lemma InsertSameElements(y: int, xs: List<int>, p: int)
   ensures Project(Cons(y, xs), p) == Project(Insert(y, xs), p)
{}

function MergeSort(xs: List<int>): List<int> {
   MergeSortAux(xs, Length(xs))
}

function MergeSortAux(xs: List<int>, len: nat): List<int>
decreases len
requires len == Length(xs)
{
    if len<2 then
     xs
     else 
var (left, right) := Split(xs, len / 2);
Merge(MergeSortAux(left, len / 2),
      MergeSortAux(right, len - len / 2))
}

function Merge(xs: List<int>, ys: List<int>): List<int>
{
   match (xs, ys)
   case (Nil, Nil) => Nil
   case (Cons(_, _), Nil) => xs
   case (Nil, Cons(_, _)) => ys
   case (Cons(x, xtail), Cons(y, ytail)) =>
      if x <= y then
         Cons(x, Merge(xtail, ys))
      else
         Cons(y, Merge(xs, ytail))
}

function Split(xs: List, n: nat): (List, List)
   requires n <= Length(xs)
ensures var (left, right) := Split(xs, n);
     Length(left) == n &&
     Length(right) == Length(xs) - n &&
     Append(left, right) == xs
{
    if n == 0 then
      (Nil, xs)
   else
      var (l, r) := Split(xs.tail, n - 1);
      (Cons(xs.head, l), r)
}

lemma MergeSortOrdered(xs: List<int>)

   ensures Ordered(MergeSort(xs))

{

   MergeSortAuxOrdered(xs, Length(xs));

}

 

lemma MergeSortAuxOrdered(xs: List<int>, len: nat)

   requires len == Length(xs)

   ensures Ordered(MergeSortAux(xs, len))

   decreases len

{

   if 2 <= len {

      var (left, right) := Split(xs, len / 2);

      MergeOrdered(MergeSortAux(left, len / 2),

                    MergeSortAux(right, len - len / 2));

   }
}
lemma MergeOrdered(xs: List<int>, ys: List<int>)

   requires Ordered(xs) && Ordered(ys)

   ensures Ordered(Merge(xs, ys))

{

}

lemma MergeSortSameElements(xs: List<int>, p: int)

   ensures Project(xs, p) == Project(MergeSort(xs), p)

{

   MergeSortAuxSameElements(xs, Length(xs), p);

}

lemma MergeSortAuxSameElements(xs: List<int>, len: nat, p: int)
   requires len == Length(xs)
   ensures Project(xs, p) == Project(MergeSortAux(xs, len), p)
   decreases len
 {
    if 2 <= len {
      var (left, right) := Split(xs, len / 2);
      calc {
         Project(MergeSortAux(xs, len), p);
      == // def. MergeSortAux
         Project(Merge(MergeSortAux(left, len / 2),
                       MergeSortAux(right, len - len / 2)), p);
      ==  { MergeSortAuxOrdered(left, len / 2);
            MergeSortAuxOrdered(right, len - len / 2);
            MergeSameElements(
               MergeSortAux(left, len / 2),
               MergeSortAux(right, len - len / 2),
            p);
          }
       Append(
          Project(MergeSortAux(left, len / 2), p),
          Project(MergeSortAux(right, len - len / 2), p));
        == { AppendProject(left, right, p); }
          Project(Append(left, right), p);
      ==
          Project(xs, p);
      }
    } else {}
}

lemma MergeSameElements(xs: List<int>, ys: List<int>, p: int)
   requires Ordered(xs) && Ordered(ys)
   ensures Project(Merge(xs, ys), p)
         == Append(Project(xs, p), Project(ys, p))
{}

lemma AppendProject(xs: List<int>, ys: List<int>, p: int)

   ensures Append(Project(xs, p), Project(ys, p))

         == Project(Append(xs, ys), p)

{

}

