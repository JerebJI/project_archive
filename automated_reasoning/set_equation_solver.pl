:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(yall)).
:- use_module(library(occurs)).

:- op(140, fy, c).
:- op(160, xfy, [u,p]).

% simple solver for set equations with one variable
% https://matematika.fri.uni-lj.si/ds/ds.pdf
% page 71

primer(x,[(x u a)=(b-x),(x u b)=x]).

nalevo1(A=B,A+B=0).
nalevo(X,R):-maplist(nalevo1,X,R).

skupaj1(A=0,B=0,A u B=0).
skupaj([],[]).
skupaj([H|T],R):-
    foldl(skupaj1,T,H,R=0).

rewrite(A+B,(A-B) u (B-A)).
rewrite(A-B,A p (c B)).
rewrite(c(c A),A).
rewrite(c(A u B),(c A)p(c B)).
rewrite(c(A p B),(c A)u(c B)).
rewrite(A p (B u C), (A p B)u(A p C)).
rewrite((B u C)p A, (B p A)u(C p A)).
rewrite((A p B)p C,A p (B p C)).
rewrite((A u B)u C,A u (B u C)).

step(X,R):-
    rewrite(A,B),
    sub_term(A,X),
    mapsubterms({A,B}/[A,B]>>true,X,R).

steps(X,R):-
    ( step(X,Y),write('='),writeeq(Y)
    ->  steps(Y,R)
    ;   R=X
    ),!.

tolist(F,X,R):-
    ( X=..[F,A,BC],BC=..[F,_,_]
    ->  tolist(F,BC,RT), R=[A|RT]
    ;   X=..[F,A,B], R=[A,B]
    ),!.

toclause(X,R):-
    tolist('u',X,R1),
    maplist([A,B]>>tolist('p',A,B),R1,R).

remcop(X,R):-maplist(list_to_set,X,R).

remcontra(X,R):-
    exclude([A]>>(member(B,A),member(c B,A)),X,R).

remred(X,R):-
    exclude({X}/[A]>>(delete(X,A,XA),
                      member(C,XA),
                      subset(C,A)),X,R).

addx(_,[],[]).
addx(X,[H|T],R):-
    ( (member(X,H);member(c X,H))
    ->  addx(X,T,RT),R=[H|RT]
    ;   addx(X,T,RT),R=[[X|H],[c X|H]|RT]
    ),!.

getconstr(_,[],A,B,A,B).
getconstr(X,[H|T],PA,PB,[SH|A],B):-
    select(X,H,SH), getconstr(X,T,PA,PB,A,B).
getconstr(X,[H|T],PA,PB,A,[SH|B]):-
    select(c X,H,SH), getconstr(X,T,PA,PB,A,B).

complete(X,XS,A-B):-
    upcase_atom(X,UX),
    write('Rešujem za neznanko '),write(UX),write(':'),nl,
    maplist(writeeq,XS),
    nalevo(XS,R1),
    write('Premaknem levo:'),nl,
    maplist(writeeq,R1),
    skupaj(R1,R2),
    write('Združim v eno enačbo:'),nl,
    writeeq(R2=0),
    write('Poenostavim:'),nl,
    writeeq(R2),
    steps(R2,R3),
    toclause(R3,R4),
    remcop(R4,R5),
    write('Odstranim podvojene množice:'),nl,
    writecl(R5),
    remcontra(R5,R6),
    write('Odstranim protislovne množice:'),nl,
    writecl(R6),
    remred(R6,R7),
    write('Odstranim podvojene množice:'),nl,
    writecl(R6),
    addx(X,R7,R8),
    write('Dodam iskano spremenljivko v množice brez nje:'),nl,
    writecl(R6),
    remred(R8,R9),
    write('Odstranim podvojene množice:'),nl,
    writecl(R6),
    getconstr(X,R9,[],[],A,B),
    write('Dobim končni pogoj: '),
    writeclbnl(B),
    write(' '),write('⊆'),write(' '),
    writecl(A),!.

:- op(140, yf, '𝗰').
:- op(160, xfy, ['∪','∩','∖']).
utfy(X u Y,'∪'(X,Y)).
utfy(X p Y,'∩'(X,Y)).
utfy(X - Y,'∖'(X,Y)).
utfy(c X, '𝗰'(X)).
utfy(0,'∅').
upcase(X,Y):-
    ( atomic(X)
    ->  upcase_atom(X,Y)
    ;   fail
    ),!.
utfys(X,R):-
    mapsubterms(utfy,X,Y),
    mapsubterms(upcase,Y,Z),
    ( X=Z
    ->  X=R
    ;   utfys(Z,R)
    ),!.

writeeqbnl(X):-
    utfys(X,Z),
    write(Z).

writeeq(X):-writeeqbnl(X),nl.

unl(F,X,R1):-
    reverse(X,XR),
    foldl({F}/[A,B,C]>>(C=..[F,A,B]),XR,[],R),
    mapsubterms([A,B]>>(A=..[F,B,[]]),R,R1).

writeclbnl([[]]):-write('∅'),!.
writeclbnl(X):-
    maplist([A,B]>>unl('p',A,B),X,Y),
    unl('u',Y,E),
    writeeqbnl(E).
writecl([[]]):-write('∅'),!.
writecl(X):-writeclbnl(X),nl,!.

% example input:
% primer(X,XS),complete(X,XS,R).
