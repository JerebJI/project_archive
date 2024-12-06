ghost predicate Plateau<T(!new)>(s: seq<T>, lo: nat, hi: nat)
requires 0 <= lo <= hi <= |s|
{
  forall i :: lo<=i<hi ==> s[i]==s[lo]
}

ghost predicate LongestPlateauL(s: seq<int>, r:nat)
{
    forall l,h :: 0<=l<=h<=|s| && Plateau(s,l,h) ==> h-l <= r
}

lemma SmallestPlateau(s: seq<int>, r:nat)
requires LongestPlateauL(s,r)
requires |s|>0
ensures r>=1
{
    assert 0<=0<=1<=|s| && Plateau(s,0,1);
}

lemma Dist(s: seq<int>, r: nat, d: nat)
requires exists l,h :: 0<=l<=h<=|s| && Plateau(s,l,h) && h-l == r
requires exists l,h :: 0<=l<=h<=|s| && Plateau(s,l,h) && h-l == d
requires LongestPlateauL(s,r)
requires LongestPlateauL(s,d)
ensures r==d
{}

lemma ExpandPlateauDiff(s: seq<int>, r: nat, lo: nat, hi: nat)
requires 0 <= lo <= hi < |s|
requires hi==|s|-1
requires Plateau(s,lo,hi)
requires |s|>=2
requires s[|s|-1]!=s[|s|-2]
requires LongestPlateauL(s[..|s|-1],r) 
ensures LongestPlateauL(s,r)
{
    calc {
        LongestPlateauL(s,r);
        ==
        (forall l,h :: 0<=l<=h<|s| && Plateau(s,l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        ==
        (forall l,h :: 0<=l<=h<=|s|-1 && Plateau(s,l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        ==
        (forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s,l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        == {assert forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s,l,h) ==>
                Plateau(s[..|s|-1],l,h);}
        (forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s[..|s|-1],l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        ==
        LongestPlateauL(s[..|s|-1],r) &&
        forall l :: 0<=l<=|s| && Plateau(s,l,|s|) ==> |s|-l<=r;
        ==
        LongestPlateauL(s[..|s|-1],r) &&
        forall l :: 0<=l<=|s| && Plateau(s,l,|s|) ==> |s|-l<=r;
    }
    SmallestPlateau(s[..|s|-1],r);
    assert r>=1;
    assert forall l :: 0<=l<=|s| && Plateau(s,l,|s|) ==> |s|-l<=r;
}


lemma ExpandPlateauEqBig(s: seq<int>, r: nat, lo:nat, hi:nat)
requires r==hi-lo
requires 0 <= lo <= hi < |s|
requires hi==|s|-1
requires Plateau(s,lo,hi)
requires lo<|s| && (lo==0 || s[lo-1]!=s[lo])
requires |s|>=2
requires s[|s|-1]==s[|s|-2]
requires LongestPlateauL(s[..|s|-1],r)
ensures LongestPlateauL(s,r+1)
{
    calc {
        LongestPlateauL(s,r+1);
        ==
        (forall l,h :: 0<=l<=h<|s| && Plateau(s,l,h) ==> h-l<=r+1) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r+1;
        ==
        (forall l,h :: 0<=l<=h<=|s|-1 && Plateau(s,l,h) ==> h-l<=r+1) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r+1;
        ==
        (forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s,l,h) ==> h-l<=r+1) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r+1;
        == {assert forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s,l,h) ==>
                Plateau(s[..|s|-1],l,h);}
        (forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s[..|s|-1],l,h) ==> h-l<=r+1) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r+1;
        ==
        LongestPlateauL(s[..|s|-1],r+1) &&
        forall l :: 0<=l<=|s| && Plateau(s,l,|s|) ==> |s|-l<=r+1;
        ==
        LongestPlateauL(s[..|s|-1],r+1) &&
        forall l :: 0<=l<=|s| && Plateau(s,l,|s|) ==> |s|-l<=r+1;
    }
}


lemma ExpandPlateauEqSm(s: seq<int>, r: nat, lo: nat, hi: nat)
requires 0<=lo<hi<=|s|
requires Plateau(s,lo,hi)
requires hi==|s|-1
requires lo<|s| && (lo==0 || s[lo-1]!=s[lo])
requires |s|>=2
requires r>hi-lo
requires s[|s|-1]==s[|s|-2]
requires LongestPlateauL(s[..|s|-1],r) 
ensures LongestPlateauL(s,r)
{
    calc {
        LongestPlateauL(s,r);
        ==
        (forall l,h :: 0<=l<=h<|s| && Plateau(s,l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        ==
        (forall l,h :: 0<=l<=h<=|s|-1 && Plateau(s,l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        ==
        (forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s,l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        == {assert forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s,l,h) ==>
                Plateau(s[..|s|-1],l,h);}
        (forall l,h :: 0<=l<=h<=|s[..|s|-1]| && Plateau(s[..|s|-1],l,h) ==> h-l<=r) &&
        forall l,h :: 0<=l<=h==|s| && Plateau(s,l,h) ==> h-l<=r;
        ==
        LongestPlateauL(s[..|s|-1],r) &&
        forall l :: 0<=l<=|s| && Plateau(s,l,|s|) ==> |s|-l<=r;
        ==
        LongestPlateauL(s[..|s|-1],r) &&
        forall l :: 0<=l<=|s| && Plateau(s,l,|s|) ==> |s|-l<=r;
    }
}

method LongestPlateauLengthAux(s: seq<int>, 
   ghost Lo: nat, ghost Hi: nat) returns (r: nat)
  requires 0 <= Lo <= Hi <= |s|
  requires Plateau(s,Lo,Hi)
  requires LongestPlateauL(s,Hi-Lo)
  ensures r == Hi-Lo
{
    r := 0;
    if |s|!=0 {
        r := 1;
        var lo,hi := 0,1;
        assert 0<=lo<=hi<=|s| && Plateau(s,lo,hi) && hi-lo==r;
        while hi<|s|
        invariant 0<=lo<=hi<=|s|
        invariant Plateau(s,lo,hi)
        invariant LongestPlateauL(s,Hi-Lo)
        invariant LongestPlateauL(s[..hi],r)
        invariant lo<|s| && (lo==0 || s[lo-1]!=s[lo])
        invariant exists l,h :: 0<=l<=h<=hi && Plateau(s,l,h) && h-l == r
        {
            assert s[..hi]==s[..hi+1][..|s[..hi+1]|-1];
            if s[hi]!=s[hi-1] {
                ExpandPlateauDiff(s[..hi+1],r,lo,hi);
                lo,hi := hi,hi+1;
            } else { 
                if hi+1-lo > r {
                    assert 0<=lo<=hi<=|s[..hi]| && Plateau(s[..hi],lo,hi) && hi-lo==hi-lo;
                    Dist(s[..hi],r,hi-lo);
                    ExpandPlateauEqBig(s[..hi+1],r,lo,hi);
                    r := r+1;
                } else {
                    ExpandPlateauEqSm(s[..hi+1],r,lo,hi);
                }
                hi := hi+1;
            }
        }
        assert s[..|s|]==s;
    }
    Dist(s,r,Hi-Lo);
}

method LongestPlateauLength(s: seq<int>) returns (r: nat)
  ensures LongestPlateauL(s,r)
{
    r := 0;
    if |s|!=0 {
        r := 1;
        var lo,hi := 0,1;
        assert 0<=lo<=hi<=|s| && Plateau(s,lo,hi) && hi-lo==r;
        while hi<|s|
        invariant 0<=lo<=hi<=|s|
        invariant Plateau(s,lo,hi)
        invariant LongestPlateauL(s[..hi],r)
        invariant lo<|s| && (lo==0 || s[lo-1]!=s[lo])
        invariant exists l,h :: 0<=l<=h<=hi && Plateau(s,l,h) && h-l == r
        {
            assert s[..hi]==s[..hi+1][..|s[..hi+1]|-1];
            if s[hi]!=s[hi-1] {
                ExpandPlateauDiff(s[..hi+1],r,lo,hi);
                lo,hi := hi,hi+1;
            } else { 
                if hi+1-lo > r {
                    assert 0<=lo<=hi<=|s[..hi]| && Plateau(s[..hi],lo,hi) && hi-lo==hi-lo;
                    Dist(s[..hi],r,hi-lo);
                    ExpandPlateauEqBig(s[..hi+1],r,lo,hi);
                    r := r+1;
                } else {
                    ExpandPlateauEqSm(s[..hi+1],r,lo,hi);
                }
                hi := hi+1;
            }
        }
        assert s[..|s|]==s;
    }
}