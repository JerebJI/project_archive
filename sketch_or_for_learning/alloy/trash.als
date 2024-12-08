var sig File {}
var sig Trash in File {}

fact init {
  no Trash
}

pred empty {
  some Trash and       // guard
  after no Trash and   // effect on Trash
  File' = File - Trash // effect on File
}

pred delete [f : File] {
  not (f in Trash)   // guard
  Trash' = Trash + f // effect on Trash
  File' = File       // frame condition on File
}

pred restore [f : File] {
  f in Trash         // guard
  Trash' = Trash - f // effect on Trash
  File' = File       // frame condition on File
}

pred do_something_else {
  File' = File
  Trash' = Trash
}

fact trans {
  always (do_something_else or 
                    empty or (some f : File | delete[f] or restore[f]))
}

assert restore_after_delete {
  always (all f : File | restore[f] implies once delete[f])
}

assert delete_all {
  always ((Trash = File and empty) implies after always no File)
}

check delete_all
