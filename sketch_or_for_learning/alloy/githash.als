abstract sig Object {}

sig Hash {
   obj : one Object
}

sig Commit extends Object {
     tree : one Hash
}

sig Tree extends Object {
    tree : lone Hash,
    blob : one Hash
}

sig Blob extends Object {}

pred noMultiple {
   (Commit<:tree) in Commit lone -> lone Hash
   (Tree<:tree) in Tree lone -> lone Hash
   blob in Tree lone -> one Hash
   obj in Hash one -> one Object
}

pred noCycles {
  all t : Tree | t not in t.^((Tree<:tree).obj)
}

pred allConnected {
  Blob in Commit.tree.obj.(^(Tree<:tree.obj)+iden).blob.obj
}

pred commitRoot {
   all c : Commit | no (Commit<:tree.obj).^(Tree<:tree.obj).(c.tree.obj)
}

pred hashConn {
   Commit.tree.obj in Tree
   Tree.tree.obj in Tree
   Tree.blob.obj in Blob
}

run {
hashConn
noMultiple
noCycles
allConnected
commitRoot
#Commit>1
} for 10
