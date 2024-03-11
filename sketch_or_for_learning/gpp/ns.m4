include(`foreach.m4')dnl
define(stp,(T,II_S,III_T,III_D,S,D,VI_T,VI_S,VII_D))dnl
define(fn,_$1[label="$1"];foreach(`x',stp,vst($1,x)))dnl
define(vst,`__$2$1 [label="$2"] ; _$1 -> __$2$1 ; ')dnl
define(dp,_$1)dnl
digraph regexp {
  layout=twopi
  ranksep=5;
  ratio=auto;
  fontname="Helvetica,Arial,sans-serif"
  node [fontname="Helvetica,Arial,sans-serif"]
  edge [fontname="Helvetica,Arial,sans-serif"]
  sr [label=""]
  foreach(`x',stp,`sr -> dp(x) ;')
  foreach(`x',stp,`fn(x)')
}
