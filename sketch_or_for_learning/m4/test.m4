define(`tostr',`eval($1+$3)/eval($2+$4)')
define(`tree',`ifelse(eval($1>0),1,
   `"tostr($2,$3,$4,$5)"
       -> {"tostr($2,$3,eval($2+$4),eval($3+$5))",
           "tostr(eval($2+$4),eval($3+$5),$4,$5)"}
      subgraph "tostr(decr($1),$2,$3,eval($2+$4),eval($3+$5))"
        {tree(decr($1),$2,$3,eval($2+$4),eval($3+$5))}
      subgraph "tostr(decr($1),eval($2+$4),eval($3+$5),$4,$5)"
        {tree(decr($1),eval($2+$4),eval($3+$5),$4,$5)}',
   `"eval($2+$4)/eval($3+$5)"')')dnl
digraph {
  tree(5,0,1,1,0)
}
