module PDS
open std/ord

sig Component {
  name: Name,
  main: option Service,
  export: set Service,
  import: set Service,
  version: Number
}{no import & export}

sig PDS {
  components : set Component,
  schedule: components -> Service ->? components,
  requires: components -> components
}{components.import in components.export}

fact SoundPDSs {
  all P : PDS |
    with P {
    all c : components, s : Service | --1
      let c' = c.schedule[s] {
        (some c' iff s in c.import) && (some c' => s in c'.export) }
    all c : components | c.requires = c.schedule[Service] } --2

pred AddComponent(P, P': PDSS, C: Component) {
  not c in P.components
  P'.components = P.components + c
} run AddComponent for 3
