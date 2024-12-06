datatype Option<T> = None | Some(T)

ghost predicate Less(a: set<int>, b: set<int>) {
  forall x, y :: x in a && y in b ==> x < y
}
ghost function Union<Data>(m: map<int, Data>,
                           n: Node?<Data>): map<int, Data>
  reads n
{
  if n == null then m else m + n.M
}

class Node<Data> {
  ghost var M: map<int, Data>
  ghost var Repr: set<object>
  var key: int
  var value: Data
  var left: Node?<Data>
  var right: Node?<Data>
  
  ghost predicate Valid()
    reads this, Repr
    ensures Valid() ==> this in Repr
  {
    this in Repr &&
    (left != null ==>
      left in Repr && left.Repr <= Repr &&
      this !in left.Repr &&
      left.Valid() &&
      Less(left.M.Keys, {key})) &&
    (right != null ==>
      right in Repr && right.Repr <= Repr &&
      this !in right.Repr &&
      right.Valid() &&
      Less({key}, right.M.Keys)) &&
    (left != null && right != null ==>
      left.Repr !! right.Repr) &&
    M == Union(Union(map[key := value], left), right)
  }

  constructor (key: int, value: Data)
    ensures Valid() && fresh(Repr)
    ensures M == map[key := value]
  {
    M := map[key:=value];
    this.key, this.value := key, value;
    left,right := null,null;
    Repr := {this};
  }
  function Lookup(key: int): Option<Data>
    requires Valid()
    reads Repr
    ensures key in M.Keys ==> Lookup(key) == Some(M[key])
    ensures key !in M.Keys ==> Lookup(key) == None
  {
    if key==this.key then
      Some(this.value)
    else
      if key<this.key then
        if left!=null then
          left.Lookup(key)
        else
          None
      else
        if right!=null then
          right.Lookup(key)
        else
          None
  }

  lemma MapLeftRight(key:int,n:Node<Data>)
  requires n.Valid()
  ensures key==n.key ==>
            ((n.left!=null ==> key !in n.left.M) 
         && (n.right!=null ==> key !in n.right.M))
  {}
  method {:timeLimitMultiplier 3} Add(key: int, value: Data)
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
    ensures M == old(M)[key := value]
    decreases Repr
  {
    if {
        case key==this.key =>
            assert {:split_here} true;
            this.value := value;
            M := M[key:=value];
            MapLeftRight(key,this);
            assert {:split_here} true;
        case key<this.key =>
            assert {:split_here} true;
            if left!=null {
                left.Add(key,value);
            } else {
                left := new Node(key,value);
            }
            M := M[key:=value];
            Repr := Repr+left.Repr;
            assert Valid() && fresh(Repr - old(Repr));
            assert M == old(M)[key := value];
            assert {:split_here} true;
        case key>this.key =>
            if right!=null {
                right.Add(key,value);
            } else {
                right := new Node(key,value);
            }
            Repr := Repr+right.Repr;
            M := M[key:=value];
           /* */
    }
  }

  function  Min(): (int, Data)
    requires Valid()
    reads Repr
   ensures var (k, val) := Min(); k in M.Keys && M[k] == val
   ensures var (k, val) := Min(); forall k' :: k' in M.Keys ==> k <= k'
  {
    if left == null then
      (key, value)
    else
      left.Min()
  }
  lemma Min1()
  requires Valid()
  decreases Repr
  ensures var (k, val) := Min(); k in M.Keys && M[k] == val
  {
    var (k,val) := Min();
    if left == null {
      assert var (k, val) := Min(); k in M.Keys && M[k] == val;
    } else {
      left.Min1();
    }
  }
  method Remove(key: int) returns (n: Node?<Data>)
    requires Valid()
    modifies Repr
    decreases Repr
    ensures n != null ==> n.Valid() && n.Repr <= old(Repr)
    ensures var newMap := old(M) - {key};
      (|newMap.Keys| == 0 ==> n == null) &&
      (|newMap.Keys| != 0 ==> n != null && n.M == newMap)
    {
      if key==this.key {
        if left==null {
          return right;
        } else if right==null {
          return left;
        } else {
          var (k,val) := right.Min();
          this.key, this.value := k, val;
          right := right.Remove(k);
        }
      } else if key < this.key && left != null {
        left := left.Remove(key);
      } else if this.key < key && right != null {
        right := right.Remove(key);
      }
      M := M - {key};
      return this;
    }
}

class BinarySearchTree<Data> {
  ghost var M: map<int, Data>
  ghost var Repr: set<object>
  var root: Node?<Data>
  ghost predicate Valid()
    reads this, Repr
    ensures Valid() ==> this in Repr
  {
    this in Repr &&
    (|M.Keys|==0  ==>  root==null) &&
    (|M.Keys|!=0  ==>
      root in Repr && root.Repr<=Repr && this !in root.Repr &&
      root.Valid() &&
      root.M == M)
  }
  constructor ()
    ensures Valid() && fresh(Repr)
    ensures M == map[]
  {
    M := map[];
    root := null;
    Repr := {this};
  }
  function Lookup(key: int): Option<Data>
    requires Valid()
    reads Repr
    ensures key in M.Keys ==> Lookup(key) == Some(M[key])
    ensures key !in M.Keys ==> Lookup(key) == None
  {
    if root!=null then root.Lookup(key) else None
  }
  method Add(key: int, value: Data)
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
    ensures M == old(M)[key := value]
  {
    if root!=null {
        root.Add(key,value);
    } else {
        root := new Node(key,value);
    }
    M := M[key:=value];
    Repr := Repr + root.Repr;
  }
  method Remove(key: int)
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
    ensures M == old(M) - {key}
  {
    if root!=null {
      root := root.Remove(key);
    }
    M := M-{key};
  }
}