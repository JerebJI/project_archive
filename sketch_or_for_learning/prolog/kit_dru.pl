:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(pio)).

% ODNOSI
%
% starš     - p
% sorojenec - s
% potomec   - n
%
% porocen - d
% locen   - l
%
% DOLOCILA
%
% starejsi od     - so - +
% starejsi od ego - se - *
% mlajsi od       - mo - -
% mlajsi od ego   - me - %
% nedolocen       -      e
%
% moski      - m
% zenska     - z
% nedoloceno - a

p --> "p".
s --> "s".
n --> "n".

d --> "d".
l --> "l".

so --> "so".
se --> "se".
mo --> "mo".
me --> "me".
e --> "e".

soe --> so ; e.
see --> se ; e.
moe --> mo ; e.
mee --> me ; e.

m --> "m".
z --> "z".
a --> "a".

ma --> m ; a.
za --> z ; a.

opc(a) --> a ; "".

sdru("oče") --> ma, e, p.
sdru("mati") --> za, e, p.
sdru("mož") --> ma, e, d.
sdru("žena") --> za, e, d.
sdru("sin") --> ma, e, n.
sdru("hči") --> za, e, n.
sdru("brat") --> ma, e, s.
sdru("sestra") --> za, e, s.
%sdru("starejši brat") --> .
%sdru("mlajši brat") --> .
%sdru("starejša sestra") --> .
%sdru("mlajša sestra") --> .
%sdru("očetov oče") --> .
%sdru("očetova mati") --> .
%sdru("očetov starejši brat") --> .
%sdru("žena očetovega starejšega brata") --> .
%sdru("očetov mlajši brat") --> .
%sdru("žena očetovega mlajšega brata") --> .
%sdru("očetova starejša sestra") --> .
%sdru("mož očetove starejše sestre") --> .
%sdru("") --> .

ws --> [W], { char_type(W, whitespace) }, ws.
ws --> "".
bes([C|Cs]) --> [C], {char_type(C, alpha)}, bes(Cs).
bes([]) --> "".
proga([C|Cs]) --> [C], {char_type(C, ascii)}, proga(Cs).
proga([]) --> "".
prog --> ("f";"[";",";"|";"m";"x";"b";"s";"w";"l";"o";"h";"&";"#";"0";"1"), prog.
prog --> "".
prazna_vrsta --> "\n".
komentar --> ws, "//", ws, bes(_), "\n".
prva_vrsta --> "export default {\n".
podatki(Is) --> komentar, podatki(Is).
podatki(Is) --> prazna_vrsta, podatki(Is).
podatki([[D,I]|Is]) --> pravilo(D,I), podatki(Is).
podatki([]) --> "};\n".
pravilo(D,I) --> ws, "'", drevo(D), "':[", izrazi(I).
drevo(D) --> proga(D).
izrazi([I|Is]) --> izraz(I), vizrazi(Is).
vizrazi([I|Is]) --> ",", izraz(I), vizrazi(Is).
vizrazi([]) --> "],\n".
izraz(I) --> "'", bes(I), "'".
glavno(Is) --> ws, komentar, prva_vrsta, podatki(Is).
