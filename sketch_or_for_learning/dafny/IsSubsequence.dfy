predicate TIsSubsequence(s:string, t:string) {
    forall si1,si2 :: 0<=si1<|s| && 0<=si2<|s| && si1<=si2 ==> 
           exists ti1,ti2 :: 0<=ti1<|t| && 0<=ti2<|t| && ti1<=ti2 
                          && s[si1]==t[ti1] && s[si2]==t[ti2]
}

predicate FIsSubsequence(s:string, t:string) {
    if |s|==0 then true else
    if |t|==0 then false else
    if t[0]==s[0] then
      FIsSubsequence(s[1..],t[1..])
    else
      FIsSubsequence(s,t[1..])
}

lemma Impl1(s:string, t:string) 
requires FIsSubsequence(s,t)
ensures TIsSubsequence(s,t)
{}

lemma SubSeqTrueAllTrue(s:string, t:string, i1:nat, j1:nat, i2:nat, j2:nat)
decreases j1-i1+j2-i2
requires 0<=i1<=i2<=j2<=j1<=|t|
requires FIsSubsequence(s,t[i2..j2])
ensures FIsSubsequence(s,t[i1..j1])
{
    if |s|==0 {
    } else {
        if |t|==0 {
        } else {
            if t[0]==s[0] {
                SubSeqTrueAllTrue(s,t,i1+1,j1,i2+1,j2);
                //FIsSubsequence(s[1..],t[1..])
            } else {
                //FIsSubsequence(s,t[1..])
            }
        }
    }
}

method IsSubsequence(s : string, t : string) returns (r:bool)
ensures r==FIsSubsequence(s,t)
{
    r := true;
    var i,j := 0,0;
    while i<|s| || j<|t|
      decreases |s|-i+|t|-j
      invariant 0<=i<=|s|
      invariant 0<=j<=|t|
      invariant r==FIsSubsequence(s[..i],t[..j])
    {
        if i==|s| {
            calc {
                FIsSubsequence(s[..|s|],t[..|t|]);
                =={assert t[..|t|]==t && s[..|s|]==s;}
                FIsSubsequence(s,t);
                if |s|==0 then true else
                if |t|==0 then false else
                if t[0]==s[0] then
                FIsSubsequence(s[1..],t[1..])
                else
                FIsSubsequence(s,t[1..]);
            }
            assert true==FIsSubsequence(s[..|s|],t[..|t|]);
            r,i,j:=true,|s|,|t|;
            assert r==FIsSubsequence(s[..i],t[..j]);
        } else {
            if j==|t| {
                assert false==FIsSubsequence(s[..|s|],t[..|t|]);
                r,i,j:=false,|s|,|t|;
                assert r==FIsSubsequence(s[..i],t[..j]);
            } else {
                if s[i]==t[j] {
                    assert r==FIsSubsequence(s[..i+1],t[..j+1]);
                    i,j := i+1,j+1;
                    assert r==FIsSubsequence(s[..i],t[..j]);
                } else {
                    assert r==FIsSubsequence(s[..i],t[..j+1]);
                    i,j := i,j+1;
                    assert r==FIsSubsequence(s[..i],t[..j]);
                }
            }
        }
    }
    assert t[..|t|]==t && s[..|s|]==s;
}

method Main() {
    assert FIsSubsequence("abc","ahbgdc");
    assert !FIsSubsequence("axc","ahbgdc");
}