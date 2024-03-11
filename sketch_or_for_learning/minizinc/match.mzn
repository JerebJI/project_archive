include "globals.mzn";
array [int] of int: ime = [1,2,3,4];
array [int] of int: izb  = [1,2,3,4];
array [int] of int: izb1 = [1,2,3,1];
array [int] of int: izb2 = [2,1,4,4];
array [int] of int: izb3 = [3,4,2,2];
array [int] of int: spodnja_meja = [0,0,0,0];
array [int] of int: zgornja_meja = [1,2,1,1];
array[int] of int: t1 = [i| i in ime, c in izb]++[c|c in izb];
array[int] of int: t2 = [c| i in ime, c in izb]++[length(ime)|c in izb];
function int: inter(array[int] of int: t1,array[int] of int: t2, int: i) = if i mod 2 = 0 then t1[i div 2] else t2[i div 2] endif;

array [int,1..2] of int: arc = array2d(1..length(ime)+length(izb),1..2,[inter(t1,t2,i)|i in 1..x]);

array [int] of int: balance = [-1|i in ime] ++ [0| i in izb] ++ [length(ime)];
array [int] of int: weight=[if (c=izb1[i]) then 0 else if(c=izb2[i]) then 1 else if(c=izb3[i]) then 2 else 3 endif endif endif | i in ime, c in izb] ++ [0 | c in izb];
int: x=length(ime)*length(izb);
array [int] of var int: flow;
var int: cost;

constraint forall(i in x..x+length(izb))(spodnja_meja[i]<flow[i] /\ flow[i]<zgornja_meja[i]);
constraint network_flow_cost(arc,balance,weight,flow,cost);

solve minimize cost;
