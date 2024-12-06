//tudi 16.3

ghost function Hash(s: string): int {
  SumChars(s) % 137
}

ghost function SumChars(s: string): int {
  if |s| == 0 then 0 else
    var last := |s| - 1;
    SumChars(s[..last]) + s[last] as int
}

datatype Option<T> = None | Some(T)

class ChecksumMachine {
  var sum: int
  var ocs: Option<int>
  ghost var data: string
  ghost predicate Valid()
    reads this
  {
    && sum == SumChars(data)
    && (ocs==None || ocs==Some(sum%137))
  }
  constructor ()
    ensures Valid() && data == ""
  {
    data,sum,ocs := "",0,None;
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
      invariant sum == SumChars(data)
    {
        sum := sum + d[i]as int;
        data := data + [d[i]];
        i := i+1;
    }
    ocs := Some(sum%137);
  }

  method Checksum() returns (checksum: int)
    requires Valid()
    modifies this
    ensures Valid() && data == old(data)
    ensures checksum == Hash(data)
  {
    match ocs
    case None => var r:=sum%137;
                 ocs:=Some(r);
                 return r;
    case Some(x) => return x;
  }
}

method ChecksumMachineTestHarness() {
  var m := new ChecksumMachine();
  m.Append("green");
  m.Append("grass");
  var c := m.Checksum();
  print "Checksum is ", c, "\n";
}