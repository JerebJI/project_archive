abstract sig Object {}

sig Commit extends Object {
     tree : one Tree
}

sig Tree extends Object {
    tree : lone Tree,
    blob : one Blob
}

sig Blob extends Object {}

pred noMultiple {
   (Commit<:tree) in Commit lone -> lone Tree
   (Tree<:tree) in Tree lone -> lone Tree
   blob in Tree lone -> one Blob
}

pred noCycles {
  all t : Tree | t not in t.^tree
}

pred allConnected {
  Blob in Commit.tree.(^tree+iden).blob
}

pred commitRoot {
   all c : Commit | c=(Commit<:tree).(^(Tree<:tree)+iden).(c.tree)
}

run {
noMultiple
noCycles
allConnected
commitRoot
#Tree>2
} for 10
