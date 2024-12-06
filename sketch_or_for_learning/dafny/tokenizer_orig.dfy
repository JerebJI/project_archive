datatype Category = Identifier | Number | Operator
                  | Whitespace | Error | End

predicate Is(ch: char, cat: Category)
  requires cat != End
  decreases cat == Error
{
  match cat
  case Whitespace => ch in " \t\r\n"
  case Identifier => 'A' <= ch <= 'Z' || 'a' <= ch <= 'z'
  case Number => '0' <= ch <= '9'
  case Operator => ch in "+-*/%!=><~^&|"
  case Error =>
    !Is(ch, Identifier) && !Is(ch, Number) &&
    !Is(ch, Operator) && !Is(ch, Whitespace)
}

class Tokenizer {
  const source: string
  var n: nat

  ghost predicate Valid()
    reads this
  {
    n <= |source|
  }

  constructor (s: string)
    ensures Valid() && source == s && n == 0
  {
    source, n := s, 0;
  }

  method Read() returns (cat: Category, ghost p: nat, token: string)
    requires Valid()
    modifies this
    ensures Valid()
    ensures cat!=Whitespace
    ensures old(n) <= p <= n <= |source|
    ensures cat == End <==> p == |source|
    ensures cat == End || cat == Error <==> p == n
    ensures forall i :: old(n) <= i < p  ==>  Is(source[i], Whitespace)
    ensures forall i :: p <= i < n ==> Is(source[i], cat)
    ensures p < n ==> n == |source| || !Is(source[n], cat)
    ensures token == source[p..n]
  {
    // skip initial whitespace (advance n)
    while n!=|source| && Is(source[n],Whitespace)
      invariant old(n)<=n<=|source|
      invariant forall i :: old(n)<=i<n ==> Is(source[i],Whitespace)
    {
        n := n+1;
    }
    p:=n;
    // set syntactic category
    if n == |source| {
      return End, p, "";
    } else if Is(source[n], Identifier) {
      cat := Identifier;
    } else if Is(source[n], Number) {
      cat := Number;
    } else if Is(source[n], Operator) {
      cat := Operator;
    } else {
      return Error, p, "";
    }
    // read token
    // print
    var start := n;
    n := n + 1;
    while n!=|source| && Is(source[n], cat)
      invariant p <= n <= |source|
      invariant forall i :: p <= i < n ==> Is(source[i], cat)
    {
      n := n + 1;
    }
    token := source[start..n];
  }
}

