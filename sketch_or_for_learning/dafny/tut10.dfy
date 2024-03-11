method Find(a: array<int>, key: int) returns (index: int)
  ensures 0 <= index ==> index < a.Length && a[index] == key
  ensures index < 0  ==> forall k :: 0 <= k < a.Length ==> a[k] != key
{
  return -1;
}
