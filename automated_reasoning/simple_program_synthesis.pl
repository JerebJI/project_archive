:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(yall)).
:- use_module(library(clpfd)).
:- debug.

% Simple bottom up search
% https://people.csail.mit.edu/asolar/SynthesisCourse/Lecture3.htm

% funkcija za indeksiranje seznama
index(L,A,B,R):-
    length(L,LL), % dobim dolžino seznama
    LL2 is LL-B-1, % izračunam dolžino od konca segmanta do konca
    LL2>=0, A>=0, B>=A, B=<LL, % preverim omejitve
    length(L1,A),length(L2,LL2), % zahtevam razdaljo
    append(L1,LR,L),append(R,L2,LR),!. % | L1 | R | L2 | = L

% funkcija, ki vrne indeks prve ničle v seznamu
first0([0|_],0):-!.
first0([X|T],R):-X\=0,first0(T,RT),R is RT+1.

/* Dani jezik:
lstExpr := sort(lstExpr)            sorts a list given by lstExpr.
           lstExpr[intExpr,intExpr] selects sub-list from the list given by the start and end position
           lstExpr+lstExpr          concatenates two lists
           recursive(lstExpr)       calls the program recursively on its argument list; if the list is empty, returns empty without a recursive call
           [0]                      a list with a single entry containing the number zero
           in                       the input list in
intExpr := firstZero(lstExpr) position of the first zero in a list
           len(lstExpr)       length of a given list
           0                  constant zero
           intExpr+1          adds one to a number

Spremembe (zato da lahko iz funktorja izveš tip izraza):
  lstExpr[intExpr,intExpr] --> ind(lstExpr,intExpr,intExpr)
  [0]                      --> list([0])
  intExpr+1                --> succ(intExpr)
Razlike v delovanju (da se sklada s primerom obračanja: recursive(in[0+1,len(in)])+in[0,0]):
  len --> len-1
  nisem pa uskladil s tabelo... (ne vem kaj naj prioritiziram)
*/

% evl(+P,+Op,+I,-R,+G)
% P  - celoten program (potreben za izvajanje rekurzije)
% Op - del programa, ki ga je treba izvesti
% I  - primeri vhoda (za observational equivalence)
% R  - rezultat izvedbe
% G  - (Gas) število dovoljenih operacij (programi se lahko zaciklajo)
evl(_,list([0]),_,[0],_).

evl(_,in,X,X,_).

evl(P,sort(X),I,R,G):-
    G>0,G1 is G-1,
    evl(P,X,I,R1,G1),
    sort(R1,R).

evl(P,ind(X,Y,Z),I,R,G):-
    G>0,G1 is G-1,
    evl(P,X,I,RX,G1),evl(P,Y,I,RY,G1),evl(P,Z,I,RZ,G1),
    index(RX,RY,RZ,R).

evl(P,X+Y,I,R,G):-
    G>0,G1 is G-1,
    evl(P,X,I,RX,G1),evl(P,Y,I,RY,G1),
    append(RX,RY,R).

evl(P,recursive(X),I,R,G):-
    G>0,G1 is G-1,
    evl(P,X,I,RX,G1),
    (RX=[] -> R=[] ; evl(P,P,RX,R,G1)).

evl(_,0,_,0,_).

evl(P,succ(X),I,R,G):-
    G>0,G1 is G-1,
    evl(P,X,I,RX,G1),
    R is RX+1.

evl(P,firstZero(X),I,R,G):-
    G>0,G1 is G-1,
    evl(P,X,I,RX,G1),
    first0(RX,R).

evl(P,len(X),I,R,G):-
    G>0,G1 is G-1,
    evl(P,X,I,RX,G1),
    length(RX,R1),R is R1-1. % drugače ne dela dani primer...

eval(P,I,R,G):-evl(P,P,I,R,G). % glavni predikat

terminals([in,list([0]),0]). % baza induktivne definicije

% predikat, ki preveri oz. pove ti izraza (int/list)
gtype(lstExpr,X):-X=..[H|_],
    member(H,[list,in,sort,ind,'+',recursive]).
gtype(intExpr,X):-X=..[H|_],
    member(H,[0,succ,firstZero,len]).

% predikat, ki vrne določen tip izraza
getE(X,T,L):-member(X,L),gtype(T,X).

% predikat, ki iz seznama izrazov vrne iste izraze, skupaj z novimi sestavljenih iz njih (globina+1)
grow1(I,sort(X))     :- getE(X,lstExpr,I).
grow1(I,ind(X,Y,Z))  :- getE(X,lstExpr,I),getE(Y,intExpr,I),getE(Z,intExpr,I).
grow1(I,X+Y)         :- getE(X,lstExpr,I),getE(Y,lstExpr,I).
grow1(I,recursive(X)):- getE(X,lstExpr,I).
grow1(I,succ(X))     :- getE(X,intExpr,I).
grow1(I,firstZero(X)):- getE(X,lstExpr,I).
grow1(I,len(X))      :- getE(X,lstExpr,I).

grow(X,Z):-findall(Z,grow1(X,Z),Y),append(X,Y,Z). % glavni predikat

% observational equivalence
% pove če sta enakovredna, glede na dane vhode
% (če se kateri zacikla, vrne ``različnost'')
obsEq(_,_,[],_).
obsEq(X,Y,[In|TI],G):-
    eval(X,In,R,G),eval(Y,In,R,G),obsEq(X,Y,TI,G).

% preveri, če se predikat ``zacikla''
loops(X,I,G):- \+obsEq(X,X,I,G).

% dela prav samo zaradi definicij se ne sklada čisto z lekcijami...
elimEquiv([],[],_,_).
elimEquiv([X|T],R,I,G):-
     elimEquiv(T,TR,I,G),
    ((loops(X,I,G) ; member(Y,T),obsEq(X,Y,I,G))
    -> R=TR
    ; R=[X|TR]).

% pove, če se programa sklada s pari vhod/izhod
correct(_,[],[],_).
correct(X,[I|TI],[O|TO],G):-
    eval(X,I,O,G),correct(X,TI,TO,G).

% glavni sintetizator
% (za jezik, ki sicer temu postopku ni primeren... Context independent equivalence)
% bus_synth(-R,+I,+O,+G)
% R - najden program
% I - primeri vhodov
% O - primeri izhodov
% G - max število korakov
bus_synth(R,I,O,G):-
    terminals(PList),
    bus_loop(PList,R,I,O,G).
bus_loop(X,R,IN,OUT,G):-
    grow(X,X1),
    elimEquiv(X1,X2,IN,G),
    (  member(M,X2),correct(M,IN,OUT,G)
    -> R=M
    ;  bus_loop(X2,R,IN,OUT,G)  ).
