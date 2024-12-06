ghost function Hash(s: string): int {
  SumChars(s) % 137
}

ghost function SumChars(s: string): int {
  if |s| == 0 then 0 else
    var last := |s| - 1;
    SumChars(s[..last]) + s[last] as int
}

function SumChars1(s: string): int {
  if |s| == 0 then 0 else
    var last := |s| - 1;
    SumChars1(s[..last]) + s[last] as int
}

lemma SumCharsEq(s:string)
ensures SumChars(s)==SumChars1(s)
{}

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
        cs := (cs + d[i]as int)%137;
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