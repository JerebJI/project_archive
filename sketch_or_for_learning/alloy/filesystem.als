abstract sig Object {}

sig Entry {
  name : one Name,
  object : one Object
}
sig Name {}

sig File extends Object {}
sig Dir extends Object {
  entries : set Entry
}

one sig Root extends Dir {}

fact {
  // Entries cannot be shared between directories
  // Entries must belong to exactly one a directory
  entries in Dir one -> Entry
}

fact {
  // Different entries in the same directory must have different names
  all d : Dir, disj x,y : d.entries | x.name != y.name
}

fact {
  // A directory cannot be contained in more than one entry
  all d : Dir | lone object.d
}

fact {
  // Every object except the root is contained somewhere
  Entry.object = Object - Root
}

fact {
  // Directories do not contain themselves directly or indiractly
  all d : Dir | d not in d.^(entries.object)
}

assert no_partitions {
  // Every object is reachable from the root
  Object - Root = Root.^(entries.object)
}

check no_partitions

run example {
  some File
  some Dir - Root
} for 4
