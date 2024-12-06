datatype Category = Identifier | Number | Operator
                  | Whitespace | Error | End

predicate IsStart(ch: char, cat: Category)
  requires cat != End
  decreases cat == Error
{
  match cat
  case Whitespace => ch in " \t\r\n"
  case Identifier => 'A' <= ch <= 'Z' || 'a' <= ch <= 'z'
  case Number => '0' <= ch <= '9'
  case Operator => ch in "+-*/%!=><~^&|"
  case Error =>
    !IsStart(ch, Identifier) && !IsStart(ch, Number) &&
    !IsStart(ch, Operator) && !IsStart(ch, Whitespace)
}

predicate IsFollow(ch: char, cat: Category)
  requires cat != End
  decreases cat == Error
{
  match cat
  case Whitespace => ch in " \t\r\n"
  case Identifier => 'A' <= ch <= 'Z' || 'a' <= ch <= 'z' || '0' <= ch <= '9'
  case Number => '0' <= ch <= '9'
  case Operator => ch in "+-*/%!=><~^&|"
  case Error =>
    !IsFollow(ch, Identifier) && !IsFollow(ch, Number) &&
    !IsFollow(ch, Operator) && !IsFollow(ch, Whitespace)
}

predicate Is(ch: char, cat: Category)
  requires cat != End
  decreases cat == Error
{
    IsStart(ch,cat) || IsFollow(ch,cat)
}

class Tokenizer {
  ghost const source: string
  var suffix: string
  ghost var n: nat
  var m: nat
  var j: nat

  ghost predicate Valid()
    reads this
  {
    n <= |source| && m<=|source| && suffix == source[m..] && n==m+j
  }

  constructor (s: string)
    ensures Valid() && source == s && n == 0
  {
    source, suffix, n, m, j := s, s, 0, 0, 0;
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
    ensures forall i :: p < i < n ==> IsFollow(source[i], cat)
    ensures p<|source| ==> IsStart(source[p], cat)
    ensures p < n ==> n == |source| || !IsFollow(source[n], cat)
    ensures token == source[p..n]
  {
    // skip initial whitespace
    while j!=|suffix| && Is(suffix[j],Whitespace)
      invariant Valid()
      invariant 0<=j<=|suffix|
      invariant old(n)<=n<=|source|
      invariant forall i :: old(n)<=i<n ==> Is(source[i],Whitespace)
    {
        n,j := n+1,j+1;
    }
    p:=n;
    // identify/memorize syntactic category
    if j == |suffix| {
      return End, p, "";
    } else if IsStart(suffix[j], Identifier) {
      cat := Identifier;
    } else if IsStart(suffix[j], Number) {
      cat := Number;
    } else if IsStart(suffix[j], Operator) {
      cat := Operator;
    } else {
      return Error, p, "";
    }
    
    // read token
    // find end of largest segment of body chars of set token category
    var start := j;
    n,j := n+1,j+1;
    while j!=|suffix| && IsFollow(suffix[j], cat)
      invariant Valid()
      invariant start < j
      invariant 0 <= j <= |suffix|
      invariant p <= n <= |source|
      invariant forall i :: p <= i < n ==> Is(source[i], cat)
      invariant source[p..n]==suffix[start..j]
    {
      n,j := n+1,j+1;
    }
    token := suffix[start..j];
    m,j,suffix := m+j,0,suffix[j..];
  }
}

