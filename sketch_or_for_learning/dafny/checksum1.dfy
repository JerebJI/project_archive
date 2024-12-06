ghost function Hash(s: string): int {
  SumChars(s) % 137
}

ghost function SumChars(s: string): int {
  if |s| == 0 then 0 else
    (s[0]as int) + SumChars(s[1..])
}

lemma IndexFirstSeq(s1:seq,s2:seq)
requires |s1|>0
ensures (s1+s2)[1..]==s1[1..]+s2
{}

lemma SumCharsAdd(s:string, c:char)
ensures SumChars(s)+c as int==SumChars(s+[c])
{
    if |s|==0 {
        assert SumChars(s)+c as int==SumChars(s+[c]);
    } else {
        assert |s|>0;
        calc {
            SumChars(s+[c]);
            if |s+[c]| == 0 then 0 else ((s+[c])[0]as int) + SumChars((s+[c])[1..]);
            if |s|+1==0 then 0 else ((s+[c])[0]as int) + SumChars((s+[c])[1..]);
            ((s+[c])[0]as int) + SumChars((s+[c])[1..]);
            { IndexFirstSeq(s,[c]); }
            (s[0]as int) + SumChars(s[1..]+[c]);
            (s[0]as int) + SumChars(s[1..])+c as int;
            SumChars(s)+c as int;
        }
    }
}

class ChecksumMachine {
  var cs: int
  ghost var data: string
  ghost predicate Valid()
    reads this
  {
    cs == Hash(data)
  }
  constructor ()
    ensures Valid() && data == ""
  {
    data,cs := "",0;
  }
  method Append(d: string)
    requires Valid()
    modifies this
    ensures Valid() && data == old(data) + d
  {
    var i := 0;
    while i!=|d|
      invariant 0<=i<=|d|
      invariant data == old(data)+d[..i]
      invariant Valid()
    {
        cs := (d[i]as int + cs)%137;
        SumCharsAdd(data,d[i]);
        data := data + [d[i]];
        i := i+1;
    }
  }

  function Checksum(): int
    requires Valid()
    reads this
    ensures Valid() && Checksum() == Hash(data)
  {
    cs
  }
}

method ChecksumMachineTestHarness() {
  var m := new ChecksumMachine();
  m.Append("green");
  m.Append("grass");
  var c := m.Checksum();
  print "Checksum is ", c, "\n";
}