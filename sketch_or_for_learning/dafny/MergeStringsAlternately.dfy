function Min(a : int, b : int) : int {
    if a>b then b else a
}

// Leetcode: 1768. Merge Strings Alternately

method MergeStringsAlternately(s1 : array<char>, s2 : array<char>) returns (r:array<char>)
ensures r.Length == s1.Length + s2.Length
ensures forall i :: 0<=i<2*Min(s1.Length,s2.Length) ==> 
                        if i%2==0 then r[i]==s1[i/2] else r[i]==s2[(i-1)/2]
ensures forall i :: 2*Min(s1.Length,s2.Length)<=i<r.Length ==>
                        if s1.Length==Min(s1.Length,s2.Length) then
                          r[i]==s2[i-Min(s1.Length,s2.Length)]
                        else
                          r[i]==s1[i-Min(s1.Length,s2.Length)]
{
    r := new char[s1.Length+s2.Length];
    var j,i1,i2 := 0,0,0;
    while j<r.Length
      invariant r.Length==s1.Length+s2.Length
      invariant 0<=j<=r.Length
      invariant 0<=i1<=s1.Length
      invariant 0<=i2<=s2.Length
      invariant j==i1+i2
      invariant i1<s1.Length || i2<s2.Length || i1+i2==r.Length
      invariant 0<=j<2*Min(s1.Length,s2.Length) ==> 
                   if j%2==0 then i1==j/2 else i2==(j-1)/2
      invariant forall i :: (i<j && 0<=i<2*Min(s1.Length,s2.Length)) ==> 
                        if i%2==0 then r[i]==s1[i/2] else r[i]==s2[(i-1)/2]
      invariant 2*Min(s1.Length,s2.Length)<=j<r.Length ==> 
                   if s1.Length==Min(s1.Length,s2.Length) then 
                     i2==j-Min(s1.Length,s2.Length) 
                   else 
                     i1==j-Min(s1.Length,s2.Length)
      invariant forall i :: (i<j && 2*Min(s1.Length,s2.Length)<=i<r.Length) ==>
                        if s1.Length==Min(s1.Length,s2.Length) then
                          r[i]==s2[i-Min(s1.Length,s2.Length)]
                        else
                          r[i]==s1[i-Min(s1.Length,s2.Length)]
    {
        if {
            case || (j%2==0 && i1< s1.Length)
                 || (j%2==1 && i2>=s2.Length) => r[j], i1 := s1[i1], i1+1;
            case || (j%2==1 && i2< s2.Length)
                 || (j%2==0 && i1>=s1.Length) => r[j], i2 := s2[i2], i2+1;
        }
        j := j+1;
    }
}

method Main() {
    var s1 : array<char> := new char[2](i requires 0<=i<2 =>"aa"[i]);
    var s2 : array<char> := new char[3](i requires 0<=i<3 =>"bbc"[i]);
    var r := MergeStringsAlternately(s1,s2);
    assert r[..]=="ababc";
}