:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(yall)).
:- use_module(library(gensym)).
:- use_module(library(occurs)).

:- op(140, fy, neg).
:- op(160, xfy, [and,or,imp]).
:- op(160, xfy, [eq]).

comps(V, X and Y,      [[n(V,X),n(V,Y)]]).
comps(V, neg(X and Y), [[n(V,neg X)],[n(V,neg Y)]]).
comps(V, X or Y,       [[n(V,X)],[n(V,Y)]]).
comps(V, neg(X or Y),  [[n(V,neg X),n(V,neg Y)]]).
comps(V, X imp Y,      [[n(V,neg X)],[n(V,Y)]]).
comps(V, neg(X imp Y), [[n(V,X),n(V,neg Y)]]).
comps(V, X eq Y,       [[n(V,X imp Y),n(V,Y imp X)]]).
comps(V, neg(X eq Y),  [[n(V,neg(X imp Y))],[n(V,neg(Y imp X))]]).
comps(V, neg(neg X),   [[n(V,X)]]).
comps(V, neg true,     [[n(V,false)]]).
comps(V, neg false,    [[n(V,true)]]).

getall(all(V,B),V,B).
getall(neg some(V,B),V,neg B).
getsome(some(V,B),V,B).
getsome(neg all(V,B),V,neg B).

step([OH|OT],QDepth,R,QDepth):-
    select(n(FVars,F),OH,NOH),
    comps(FVars,F,C),
    maplist({NOH}/[A,B]>>append(A,NOH,B),C,NF),
    append(NF,OT,R).

step([OH|OT],QDepth,[[n(FVars,NF)|NOH]|OT],QDepth):-
    select(n(FVars,E),OH,NOH),
    getsome(E,V,B),
    gensym('_f',SF),
    F=[SF|FVars],
    subs(B,V,F,NF).

step([OH|OT],QDepth,R,QDepth1):-
    select(n(FVars,E),OH,NOH),
    getall(E,V,B),
    QDepth>0,
    gensym('_v',NV),
    subs(B,V,+NV,NF),
    append([n([+NV|FVars],NF)|NOH],[],O1),
    append(OT,[O1],R),
    QDepth1 is QDepth-1.

step([OH|OT],Q,[OH|RT],NQ):- step(OT,Q,RT,NQ).

expand(Tree,QDepth,NTree):-
    ( step(Tree,QDepth,TTree,TQDepth)
    ->  expand(TTree,TQDepth,NTree)
    ;   NTree=Tree
    ).

subs(B,+V,X,R) :-
    mapsubterms({V,X}/[+V,X]>>true,B,R).

partval(X,Env,Y):-
    ( member([X,Z],Env)
    ->  partval(Z,Env,Y)
    ;   Y=X
    ).

in(X,Y,Env):-
    partval(Y,Env,Y1),
    ( X==Y1
    ; Y1\=(+_), \+atomic(Y1),
      Y1=..[_|T], exclude({X,Env}/[A]>>in(X,A,Env),T,[])
    ).

unify(X,Y,Env,NEnv):-
    partval(X,Env,X1),
    partval(Y,Env,Y1),
    ( X1==Y1, NEnv=Env
    ; X1=(+_), \+in(X1,Y1,Env), NEnv=[[X1,Y1]|NEnv]
    ; Y1=(+_), \+in(Y1,X1,Env), NEnv=[[Y1,X1]|NEnv]
    ; X1\=(+_), Y1\=(+_), \+atomic(X1), \+atomic(Y1),
      X1=..[F|XR], Y1=..[F|YR],
      uniflist(XR,YR,Env,NEnv)
    ).

uniflist([],[],E,E).
uniflist([H1|T1],[H2|T2],Env,NEnv):-
    unify(H1,H2,Env,Env1),
    uniflist(T1,T2,Env1,NEnv).

atomicf(X):-
    \+ comps(_,X,_),
    X \= neg _.

closed([],_).

closed([H|T],Env):-
    member(n(_,false),H),
    closed(T,Env).

closed([H|T],Env):-
    member(n(_,X),H),
    atomicf(X),
    member(n(_,neg Y),H),
    unify(X,Y,Env,NEnv),
    closed(T,NEnv).

test(X,QDepth):-
    expand([[n([],neg X)]],QDepth,Tree),
    ( closed(Tree,[])
    ->  write('Proved at '),write(QDepth),write('.'),nl
    ;   write('Disproved at '),write(QDepth),write('.'),nl
    ),!.
