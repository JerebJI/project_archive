method loop() {
    var x := 0;
    while x!=100
      invariant true
    assert x==100;

    x := 20;
    while x < 20
    invariant x % 2 == 0
    assert x>=20 && x%2==0;
    //assert (x == 20);

    var i := 0;
    while i < 100
      invariant 0 <= i <= 100
    assert i == 100;

    i := 100;
    while 0 < i
      invariant 0 <= i
    assert i == 0;

    i := 0;
    while i < 97
      invariant 0 <= i <= 99
      invariant i!=98 && i!=97
    assert i == 99;

    i := 22;
    while i % 5 != 0
      invariant 10 <= i <= 100
      invariant 22 <= i < 60
      invariant (22*55)%i ==0
    assert i == 55;

    x := 0;
    var y := 191;
    while 7 <= y
      invariant 0 <= y && 7 * x + y == 191
    {
        assert 0<=y && 7*x+y==191 && 7<=y;
        assert 0 <= y - 7 && 7 * x + 7 + (y - 7) == 191;
        y := y-7;
        assert 0 <= y && 7 * x + 7 + y == 191;
        assert 0 <= y && 7 * (x + 1) + y == 191;
        x:=x+1;
        assert 0<=y && 7*x+y==191;
    }
    assert x==191/7 && y == 191 % 7;

    var n,s := 0,0;
    while n!=33
      invariant s==n*(n-1)/2
    {
        s := s+n;
        n := n+1;
    }

    assume x%2==0;
    while x<300
      invariant x%2==0
    {
        x:=300;
    }

    assume 0<=x<=100;
    while x%2==1
      invariant 0<=x<=100
    {
        x:=0;
    }

    x := 0;
    while x < 100
      invariant x%3==0
      invariant x<103
    {
        x := x + 3;
    }
    assert x>=100 && x%3==0 && x<103;
    assert x == 102;
}

method UpWhileLess(N: int) returns (i: int)
requires 0 <= N
ensures i == N
{
    i := 0;
    while i < N
    decreases N-i
    invariant i<=N 
    {
        i := i + 1;
    }
}
method UpWhileNotEqual(N: int) returns (i: int)
requires 0 <= N
ensures i == N
{
    i := 0;
    while i != N
    decreases N-i
    invariant i<=N
    {
        i := i + 1;
    }
}

method DownWhileNotEqual(N: int) returns (i: int)
requires 0 <= N
ensures i == 0
{
    i := N;
    while i != 0
    invariant i>=0
    decreases i
    {
        i := i - 1;
    }
}


method DownWhileGreater(N: int) returns (i: int)
requires 0 <= N
ensures i == 0
{
    i := N;
    while 0 < i
    invariant i>=0
    decreases i
    {
        i := i - 1;
    }
}

method SquareRoot(N: nat) returns (r: nat)
ensures r * r <= N < (r + 1) * (r + 1)
{
    r:=0;
    while N>=(r+1)*(r+1)
      invariant r*r<=N
    {
        r:=r+1;
    }
}
method SquareRoot1(N: nat) returns (r: nat)
ensures r * r <= N < (r + 1) * (r + 1)
{
    r:=0;
    var s := 1;
    while N>=(r+1)*(r+1)
      invariant r*r<=N
      invariant s==(r+1)*(r+1)
    {
        assert s==(r+1)*(r+1);
        s := s+2*r+3;
        assert s==(r+1)*(r+1)+2*r+3;
        assert s==(r+1+1)*(r+1+1);
        r := r+1;
        assert s==(r+1)*(r+1);
    }
}

method rep<T>(d:T,n:nat) returns (r:seq<T>)
ensures |r|==n
ensures forall i :: 0<=i<|r| ==> r[i]==d
{
    var i := 0;
    r := [];
    while i<n
      invariant i<=n
      invariant |r| == i
      invariant forall j :: 0<=j<i ==> r[j]==d
    {
        r := r+[d];
        i := i+1;
    }

}

method Cube(n: nat) returns (c: nat)
ensures c == n * n * n
{
    c := 0;
    var i:=0;
    var s1,s2:=0,0;
    while i<n
    invariant i<=n
    invariant c==i*i*i
    invariant s1==3*i
    invariant s2==3*i*i
    {
        assert c==i*i*i;
        s1, s2 := s1+3, s2+s1+s1+3;
        calc {
            3*(i+1);
            3*i + 3;
        }
        calc {
            3*(i+1)*(i+1);
            (3*i+3)*(i+1);
            3*i*i+3*i+3*i+3;
        }
        assert s1==3*(i+1) && s2==3*(i+1)*(i+1);
        i:=i+1;
        assert s1==3*i;
        assert c==(i-1)*(i-1)*(i-1);
        calc {
            (i-1)*(i-1)*(i-1);
            i*(i-1)*(i-1)-(i-1)*(i-1);
            (i*i-i)*(i-1)-(i*i-2*i+1);
            i*i*i - i*i - i*i + i - i*i + 2*i - 1;
            i*i*i - 3*i*i + 3*i - 1;
        }
        c:=c + s2 - s1 + 1;
        assert c==i*i*i && s1==3*i && s2==3*i*i;
    }
}

method Cube1(n: nat) returns (c: nat)
ensures c == n * n * n
{
    var i := 0;
    c:=0;
    while i<n
    invariant i<=n
    invariant c==i*i*i
    {
        assert c==i*i*i;
        i:=i+1;
        assert c==(i-1)*(i-1)*(i-1);
        calc {
            (i-1)*(i-1)*(i-1);
            i*(i-1)*(i-1)-(i-1)*(i-1);
            (i*i-i)*(i-1)-(i*i-2*i+1);
            i*i*i - i*i - i*i + i - i*i + 2*i - 1;
            i*i*i - 3*i*i + 3*i - 1;
        }
        c:=i*i*i;
        assert c==i*i*i;
    }
}

ghost function Power(n: nat): nat {
  if n == 0 then 1 else 2 * Power(n - 1)
}

method ComputePower(n: nat) returns (p: nat)
ensures p == Power(n)
{
    p := 1;
    var i := 0;
    while i < n
      invariant 0 <= i <= n
      invariant p == Power(i)
    {
        p:=2*p;
        assert 0<=i+1<=n && p==2*Power(i);
        assert 0<=i+1<=n && p==Power(i+1);
        i:=i+1;
        assert 0<=i<=n && p==Power(i);
    }
}

ghost function Exp(b: nat, n: nat): nat {
    if n==0 then 1 else b*Exp(b, n-1)
}

lemma ExpAddExponent(b: nat, m: nat, n: nat)
ensures Exp(b, m + n) == Exp(b, m) * Exp(b, n)
{
    if  {
        case m<=1 || n<=1 => assert Exp(b, m + n) == Exp(b, m) * Exp(b, n);
        case m>1 && n>1 =>
        calc {
            Exp(b,m+n);
            if m+n==0 then 1 else b*Exp(b,m+n-1);
            if m+n==0 then 1 else b*(if m+n-1==0 then 1 else b*Exp(b,m+n-2));
            if m+n==0 then 1 else if m+n-1==0 then b else b*b*Exp(b,m+n-2);
            b*b*Exp(b,(m-1)+(n-1));
            {ExpAddExponent(b,m-1,n-1);}
            b*b*Exp(b,m-1)*Exp(b,n-1);
            b*Exp(b,m-1)*b*Exp(b,n-1);
            Exp(b,m)*Exp(b,n);
        }
    }
}

lemma ExpSquareBase(b: nat, n: nat)
ensures Exp(b * b, n) == Exp(b, 2 * n)
{
    if {
        case n==0 =>
        case n>0 =>
            calc {
                Exp(b*b, n);
                if n==0 then 1 else b*b*Exp(b*b,n-1);
                b*b*Exp(b,2*(n-1));
                b*b*Exp(b,2*n-2);
                b*b*Exp(b,2*n-2);
                b*b*Exp(b,(n-1)+(n-1));
                {ExpAddExponent(b,n-1,n-1);}
                b*Exp(b,n-1)*b*Exp(b,n-1);
            }
    }
}