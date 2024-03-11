var sig File {}
var sig Trash in File {}

fact init {
    no Trash
}

pred empty {
    some Trash and
    after no Trash and
    File' = File - Trash
}

pred delete [f : File] {
    not (f in Trash)
    Trash' = Trash + f
    File' = File
}

pred restore [f : File] {
    f in Trash
    Trash' = Trash - f
    File' = File
}

pred do_something_else {
    File' = File
    Trash' = Trash
}

fact trans {
    always (empty or (some f : File | delete[f] or restore[f]) or do_something_else)
}

assert restore_after_delete {
    always (all f : File | restore[f] implies once delete[f])
}

assert delete_all {
  always ((Trash = File and empty) implies after always no File)
}

check delete_all for 5 but 15 steps
