datatype Color = Red | White | Blue

ghost predicate Below(c: Color, d: Color) {
    c == Red || c == d || d == Blue
}

method DutchFlag(a: array<Color>)
 modifies a
 ensures forall i, j :: 0 <= i < j < a.Length ==> Below(a[i], a[j])
 ensures multiset(a[..]) == old(multiset(a[..]))
{
    var r, w, b := 0, 0, a.Length;
    while w < b
        invariant 0 <= r <= w <= b <= a.Length
        invariant forall i :: 0 <= i < r ==> a[i] == Red
        invariant forall i :: r <= i < w ==> a[i] == White
        invariant forall i :: b <= i < a.Length ==> a[i] == Blue
        invariant multiset(a[..]) == old(multiset(a[..]))
    {
        match a[w]
        case Red => a[r],a[w]:=a[w],a[r]; r,w:=r+1,w+1;
        case White => w := w+1;
        case Blue => a[b-1],a[w]:=a[w],a[b-1]; b:=b-1;
    }
}

method DutchFlag1(a: array<Color>)
 modifies a
 ensures forall i, j :: 0 <= i < j < a.Length ==> Below(a[i], a[j])
 ensures multiset(a[..]) == old(multiset(a[..]))
{
    var r, w, b := 0, a.Length, a.Length;
    while r < w
        invariant 0<=r<=w<=b<=a.Length
        invariant forall i :: 0<=i<r ==> a[i]==Red
        invariant forall i :: w<=i<b ==> a[i]==White
        invariant forall i :: b<=i<a.Length ==> a[i]==Blue
        invariant multiset(a[..])==old(multiset(a[..]))
    {
        match a[w-1]
        case Red => a[w-1],a[r]:=a[r],a[w-1]; r:=r+1;
        case White => w:=w-1; 
        case Blue => a[b-1],a[w-1]:=a[w-1],a[b-1]; w,b:=w-1,b-1;
    }
}

method BooleanFlag(a: array<bool>)
modifies a
ensures forall i,j :: 0<=i<j<a.Length ==> (a[i]==>a[j])
ensures multiset(a[..])==old(multiset(a[..]))
{
    var f,t := 0,a.Length;
    while f<t
      invariant 0<=f<=t<=a.Length
      invariant forall i :: 0<=i<f ==> a[i]==false
      invariant forall i :: t<=i<a.Length ==> a[i]==true
      invariant multiset(a[..])==old(multiset(a[..]))
    {
        match a[f]
        case true => a[f],a[t-1]:=a[t-1],a[f]; t:=t-1;
        case false => f := f+1;
    }
}

ghost predicate CBelow<T>(color: T -> Color, x: T, y: T) {
    Below(color(x),color(y))
}

method DutchFlagKey<T>(a: array<T>, color: T -> Color)
 modifies a
 ensures forall i, j :: 0 <= i < j < a.Length ==>
  CBelow(color, a[i], a[j])
 ensures multiset(a[..]) == old(multiset(a[..]))
{
    var r,w,b := 0,0,a.Length;
    while w<b
      invariant 0<=r<=w<=b<=a.Length
      invariant forall i :: 0<=i<r ==> color(a[i])==Red
      invariant forall i :: r<=i<w ==> color(a[i])==White
      invariant forall i :: b<=i<a.Length ==> color(a[i])==Blue
      invariant multiset(a[..])==old(multiset(a[..]))
    {
        match color(a[w])
        case Red => a[r],a[w]:=a[w],a[r]; r,w:=r+1,w+1;
        case White => w:=w+1;
        case Blue => a[b-1],a[w]:=a[w],a[b-1]; b:=b-1;
    }
}

function numToMulti(n:nat, c:Color) : multiset<Color> {
    if n>0 then multiset{c}+numToMulti(n-1,c) else multiset{}
}

function toMultiset(a: seq<nat>) : multiset<Color>
requires |a|==3
{
    numToMulti(a[0],Red)+numToMulti(a[1],White)+numToMulti(a[2],Blue)
}

method DutchFlagCount(a: array<Color>)
 modifies a
 ensures forall i, j :: 0 <= i < j < a.Length ==> Below(a[i], a[j])
 ensures multiset(a[..]) == old(multiset(a[..]))
{
    var count := new nat[3](_ => 0);
    var n := 0;
    while n<a.Length
      invariant multiset(a[..n])==toMultiset(count[..])
}