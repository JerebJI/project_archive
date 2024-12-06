:- use_module(library(terms)).
:- use_module(library(yall)).
:- use_module(library(apply)).
:- use_module(library(gensym)).
:- use_module(library(clpfd)).

:- use_rendering(svgtree, [list(false)]).

:- op(900, xfy, &).
:- op(900, xfy, !).
:- op(900, xfy, ?).
:- op(900, xfy, <=>).
:- op(900, fx, ~).

subs(S,[],S).
subs(S,[Y/X|T],R):-
    mapsubterms({X,Y}/[X,Y]>>true,S,R1),
    subs(R1,T,R).

incls(X,[Y|_]):-incl(X,Y).
incls(X,[_|T]):-incls(X,T).
incl(X,X).
incl(X,Y):-Y=..[_|T],incls(X,T).

vars(+X,[+X]).
vars(X,R):- X\=(+_),X=..[_|T],
    maplist(vars,T,T1),foldl(append,T1,[],T2),
    list_to_set(T2,R).

head([H|_],H).
tail([_|T],T).
unif(+V,+V,S0,S0,[]):-!.
unif(+V,X,S0,[X/(+V)|S1],[]):-
    \+incl(+V,X),
    subs(S0,[X/(+V)],S1),!.
unif(X,+V,S0,[X/(+V)|S1],[]):-
    \+incl(+V,X),
    subs(S0,[X/(+V)],S1),!.
unif(X,Y,S0,S0,T):-
    X=..[H|TX],Y=..[H|TY],
    maplist(([A,B,A-B]>>(true)),TX,TY,T),!.
unifs([],X,X).
unifs([X-Y|T],S0,S):-
    unif(X,Y,S0,S1,NS),
    append(NS,T,NT),
    unifs(NT,S1,S).
unify([],[]).
unify([_],[]).
unify([U,V|T],S):-foldl(unf,T,[U-V],R),unifs(R,[],S).
unf(A,[X-Y|T],[Y-A|[X-Y|T]]).

simpl(X,X):-X=..[H|_],\+member(H,['&','!','?','<=>','|','=>','~']).
simpl(X!Y,X!Y1):-simpl(Y,Y1).
simpl(X?Y,X?Y1):-simpl(Y,Y1).
simpl(X&Y,X1&Y1):-simpl(X,X1),simpl(Y,Y1).
simpl(X|Y,X1|Y1):-simpl(X,X1),simpl(Y,Y1).
simpl(~X,~X1):-simpl(X,X1).
simpl(~(P<=>Q), (P1|Q1)&(~P1|~Q1)):-simpl(P,P1),simpl(Q,Q1).
simpl(~(P=>Q), P1&(~Q1)):-simpl(P,P1),simpl(Q,Q1).
simpl(P<=>Q, R1&R2):-simpl(P=>Q,R1),simpl(Q=>P,R2).
simpl(P=>Q, ~P1|Q1):-simpl(P,P1),simpl(Q,Q1).

negin(X,X):-X=..[H|_],\+member(H,['&','!','?','|','~']).
negin(X!P,X!P1):-negin(P,P1).
negin(X?P,X?P1):-negin(P,P1).
negin(X&Y,X1&Y1):-negin(X,X1),negin(Y,Y1).
negin(X|Y,X1|Y1):-negin(X,X1),negin(Y,Y1).
negin(~(X!P),X?P1):-negin(~P,P1).
negin(~(X?P),X!P1):-negin(~P,P1).
negin(~(P&Q),P1|Q1):-negin(~P,P1),negin(~Q,Q1).
negin(~(P|Q),P1&Q1):-negin(~P,P1),negin(~Q,Q1).
negin(~(~P),P1):-negin(P,P1).
negin(~X,~X):-X=..[H|_],\+member(H,['&','!','?','|','~']).

movout(X,X):-X=..[H|_],\+member(H,['&','!','?','|']).
movout((X!P)&Q,S!R):-gensym('_v',S),subs(P,[S/X],P1),movout(P1&Q,R).
movout((X?P)&Q,S?R):-gensym('_v',S),subs(P,[S/X],P1),movout(P1&Q,R).
movout(Q&(X!P),S!R):-gensym('_v',S),subs(P,[S/X],P1),movout(Q&P1,R).
movout(Q&(X?P),S?R):-gensym('_v',S),subs(P,[S/X],P1),movout(Q&P1,R).
movout((X!P)|Q,S!R):-gensym('_v',S),subs(P,[S/X],P1),movout(P1|Q,R).
movout((X?P)|Q,S?R):-gensym('_v',S),subs(P,[S/X],P1),movout(P1|Q,R).
movout(Q|(X!P),S!R):-gensym('_v',S),subs(P,[S/X],P1),movout(Q|P1,R).
movout(Q|(X?P),S?R):-gensym('_v',S),subs(P,[S/X],P1),movout(Q|P1,R).
movout(X!P,X!P1):-movout(P,P1).
movout(X?P,X?P1):-movout(P,P1).
movout(A,R):-A=..[H,X,Y],member(H,['|','&']),
    X=..[HX|_], \+member(HX,['!','?']),
    Y=..[HY|_], \+member(HY,['!','?']),
    movout(X,X1), movout(Y,Y1), Z=..[H,X1,Y1],
    X1=..[HX1|_], Y1=..[HY1|_],
    (\+member(HX1,['!','?']),\+member(HY1,['!','?']) ->
    R=Z;
    movout(Z,R)).

skolem(X,X,_):-X=..[H|_],\+member(H,['&','!','?','|']).
skolem(X&Y,X1&Y1,L):-skolem(X,X1,L),skolem(Y,Y1,L).
skolem(X|Y,X1|Y1,L):-skolem(X,X1,L),skolem(Y,Y1,L).
skolem(X!P,P1,L):-skolem(P,P1,[X|L]).
skolem(X?P,P2,L):-gensym('_f',S),S1=..[S|L],subs(P,[S1/X],P1),skolem(P1,P2,L).

disdis(X,X):-X=..[H|_],\+member(H,['&','|']).
disdis(P|(Q&R),Q1&R1):-disdis(P|Q,Q1),disdis(P|R,R1).
disdis((Q&R)|P,Q1&R1):-disdis(Q|P,Q1),disdis(R|P,R1).
disdis(X&Y,X1&Y1):-disdis(X,X1),disdis(Y,Y1).
disdis(X|Y,R):- \+functor(X,'&',_),\+functor(Y,'&',_),
    disdis(X,X1),disdis(Y,Y1),
    (\+functor(X1,'&',_),\+functor(Y1,'&',_) ->
    R=(X1|Y1) ;
    disdis(X1|Y1,R)).

toCNFlist(X&Y,R):-toCNFlist(X,Xl),toCNFlist(Y,Yl),append(Xl,Yl,R).
toCNFlist(C,[C1]):-C\=(_ & _),toClause(C,C1).

toClause(X|Y,R):-toClause(X,X1),toClause(Y,Y1),append(X1,Y1,R).
toClause(X,[X]):-X\=(_ | _).

toCNF(X,R):-
    simpl(X,Y),
    negin(Y,Z),
    movout(Z,W),
    skolem(W,Q,[]),
    disdis(Q,A),
    toCNFlist(A,R1),
    maplist(list_to_set,R1,R).

proved(C,_):-member([],C),!.
proved(C,Q):-
    Q>0,
    select(C1,C,CB),
    select(C2,CB,CB1),
    select(A1,C1,C1A),
    select(~A2,C2,C2A),
    unify([A1,A2],S),
    append(C1A,C2A,CA),
    subs(CA,S,C3),
    list_to_set(C3,CS),
    Q1 is Q-1,
    append(CB1,[C1,C2],CB2),
    append([CS],CB2,CN),
    !,proved(CN,Q1).
proved(C,Q):-
    Q>0,
    select(C1,C,CB),
    select(A1,C1,C1A),
    select(A2,C1A,C2A),
    unify([A1,A2],S),
    append([A1],C2A,CA),
    subs(CA,S,C3),
    list_to_set(C3,CS),
    Q1 is Q-1,
    append(CB,[C1],CB1),
    append([CS],CB1,CN),
    !,proved(CN,Q1).

prove(X,Q):-
    toCNF(~X,C),
    ( proved(C,Q)
    ->  write('Proved in less than '),write(Q),write(' steps.'),nl
    ;   write('Cannot prove in less than '),write(Q),write(' steps.'),nl
    ),!.

% prove(~((p(+x)|q(+y)|q(+x))&((~q(a))|(   ~q(+z)))&(~p(a))),11).
