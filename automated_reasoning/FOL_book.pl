:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(yall)).

:- op(140, fy, neg).
:- op(160, xfy, [and,or,imp,revimp,uparrow,
                  downarrow,notimp,notrevimp]).
:- op(160, xfy, [eq,neq]).

% from book:
% First-Order Logic and Automated Theorem Proving
% Melvin Fitting


conjunctive(_ and _).
conjunctive(neg(_ or _)).
conjunctive(neg(_ imp _)).
conjunctive(neg(_ revimp _)).
conjunctive(neg(_ uparrow _)).
conjunctive(_ downarrow _).
conjunctive(_ notimp _).
conjunctive(_ notrevimp _).

% 3.2.2.
conjunctive(_ eq _).
conjunctive(neg(_ neq _)).
disjunctive(_ neq _).
disjunctive(neg(_ eq _)).

disjunctive(neg(_ and _)).
disjunctive(_ or _).
disjunctive(_ imp _).
disjunctive(_ revimp _).
disjunctive(_ uparrow _).
disjunctive(neg(_ downarrow _)).
disjunctive(neg(_ notimp _)).
disjunctive(neg(_ notrevimp _)).

unary(neg neg _).
unary(neg true).
unary(neg false).

components(X and Y, X, Y).
components(neg(X and Y), neg X, neg Y).
components(X or Y, X, Y).
components(neg(X or Y), neg X, neg Y).
components(X imp Y, neg X, Y).
components(neg(X imp Y), X, neg Y).
components(X revimp Y, X, neg Y).
components(neg(X revimp Y), neg X, Y).
components(X uparrow Y, neg X, neg Y).
components(neg(X uparrow Y), X, Y).
components(X downarrow Y, neg X, neg Y).
components(neg(X downarrow Y), X, Y).
components(X notimp Y, X, neg Y).
components(neg(X notimp Y), neg X, Y).
components(X notrevimp Y, neg X, Y).
components(neg(X notrevimp Y), X, neg Y).

% 3.2.2.
components(X eq Y,X imp Y,Y imp X).
components(neg(X eq Y),X notimp Y,Y notimp X).
components(X neq Y,X notimp Y,Y notimp X).
components(neg(X neq Y),X imp Y,Y imp X).

component(neg neg X, X).
component(neg true, false).
component(neg false, true).

singlestep([Conjunction | Rest],
           [[Newformula | Temporary] | Rest]):-
    member(Formula, Conjunction),
    unary(Formula) ,
    component(Formula, Newformula),
    delete(Conjunction, Formula, Temporary).

singlestep([Conjunction | Rest], 
           [[Alphaone, Alphatwo | Temporary] | Rest]):-
    member(Alpha , Conjunction),
    conjunctive(Alpha),
    components(Alpha, Alphaone, Alphatwo),
    delete(Conjunction, Alpha, Temporary).

singlestep([Conjunction | Rest], 
           [[Betaone | Temporary],
            [Betatwo | Temporary] | Rest]):-
    member(Beta, Conjunction),
    disjunctive(Beta) ,
    components(Beta, Betaone, Betatwo),
    delete(Conjunction, Beta, Temporary).

singlestep([Conjunction|Rest], [Conjunction|Newrest]):-
    singlestep(Rest, Newrest).

expand(Dis, Newdis) :-
    (   singlestep(Dis, Temp),expand(Temp , T)
    ->  Newdis=T
    ;   Newdis=Dis   ).

dualclauseform(X, Y):-
    expand([[X]], Y).

% 2.9.1.
clauseform(X,Y):-
    cfms([[X]],Y).

cfms(Con, NCon):-
    (   cfm(Con,X),cfms(X,T)
    ->  NCon=T
    ;   NCon=Con ).

cfm([Ds|T],R):-
    member(D,Ds),
    (   unary(D),component(D,C),delete(Ds,D,RD),
        list_to_set([C|RD],L),
        nsetinsets(L,T),
        R=[L|T]
    ;   conjunctive(D),components(D,D1,D2),delete(Ds,D,RD),
        list_to_set([D1|RD],L1),
        list_to_set([D2|RD],L2),
        nsetinsets(L1,T),
        nsetinsets(L2,T),
        R=[L1,L2|T]
    ;   disjunctive(D),components(D,D1,D2),delete(Ds,D,RD),
        list_to_set([D1,D2|RD],L),
        nsetinsets(L,T),
        R=[L|T]
    ).
cfm([Ds|R],[Ds|NR]):-cfm(R,NR).

% 2.9.2 negation normal form
nnf(neg(neg X),X):-!.
nnf(neg(X or Y),X1 and Y1):-nnf(neg X,X1),nnf(neg Y,Y1),!.
nnf(neg(X and Y),X1 or Y1):-nnf(neg X,X1),nnf(neg Y,Y1),!.
nnf(neg(X imp Y),X1 and Y1):-nnf(neg X,X1),nnf(Y,Y1),!.
nnf(neg(X revimp Y),X1 and Y1):-nnf(X,X1),nnf(neg Y,Y1),!.
nnf(neg(X uparrow Y),X1 and Y1):-nnf(X,X1),nnf(Y,Y1),!.
nnf(neg(X downarrow Y),X1 or Y1):-nnf(X,X1),nnf(Y,Y1),!.
nnf(neg(X notimp Y),X1 imp Y1):-nnf(X,X1),nnf(Y,Y1),!.
nnf(neg(X notrevimp Y),X1 revimp Y1):-nnf(X,X1),nnf(Y,Y1),!.
nnf(neg(X eq Y),X1 eq Y1):-nnf(neg X,X1),nnf(Y,Y1),!.
nnf(neg(X neq Y),X1 eq Y1):-nnf(X,X1),nnf(Y,Y1),!.
nnf(X,X):-atom(X),!.
nnf(neg X,neg X):-atom(X),!.
nnf(X,R):-
    X\=(neg _),X=..[F,A,B],
    nnf(A,A1),nnf(B,B1),
    R=..[F,A1,B1],!.

% 2.9.3.
remeqneq(X eq Y,(X1 imp Y1)and(Y1 imp X1)):-remeqneq(X,X1),remeqneq(Y,Y1).
remeqneq(X neq Y,(neg(X1 imp Y1))and(Y1 imp X1)):-remeqneq(X,X1),remeqneq(Y,Y1).
remeqneq(X,R):-X\=(_ eq _),X\=(_ neq _),
    X=..[H|T],maplist(remeqneq,T,T1),
    R=..[H|T1],!.

% 2.9.4.
degree(X,0):-atom(X),!.
degree(X,R):-X=..[_|T],
    maplist(degree,T,T1),
    foldl([A,B,C]>>(C is A+B),[1|T1],0,R),!.

% rank ne deluje na eq,neq (naloga ni točno def...)
rank(A,0):-atom(A),!.
rank(neg A,0):-atom(A),!.
rank(true,0):-!.
rank(false,0):-!.
rank(neg true,1):-!.
rank(neg false,1):-!.
rank(neg(neg X),R):-rank(X,RV),R is RV+1,!.
rank(X,R):-
    (conjunctive(X);disjunctive(X)),
    components(X,X1,X2),
    rank(X1,RX1),rank(X2,RX2),
    R is RX1+RX2+1,!.

closed([]).
closed([Branch|Rest]):-
    member(false,Branch),
    closed(Rest).
closed([Branch|Rest]) :-
    member(X,Branch),
    member(neg X,Branch),
    closed(Rest).

test(X):-
    (   expand([[neg X]],Y),!,closed(Y)
    -> write('Proved.')
    ;  write('Disproved.')),nl.

expand_and_close(Tableau) :- closed(Tableau),!.
expand_and_close(Tableau) :-
    singlestep(Tableau, NTableau),!,
    expand_and_close(NTableau).
test1(X):-
    (   expand_and_close([[neg X]])
    -> write('Proved.')
    ;  write('Disproved.')),nl.

% 3.2.1.
mtab(Tableau):-closed(Tableau),!.
mtab(Tableau):-
    singlestep(Tableau,[H|T]),!,
    (   closed(H)
    ->  mtab(T)
    ;   mtab([H|T])).
test2(X):-
    (   mtab([[neg X]])
    -> write('Proved.')
    ;  write('Disproved.')),nl.

% 3.3.3.
nsetinsets(XDS,T):-include({XDS}/[A]>>(list_to_set(A,AS),subset(XDS,AS),subset(AS,XDS)),T,[]).
resrule(T,[XDS|T]):-
    select(D1,T,T1),select(X,D1,XD1),
    select(D2,T1,_),select(neg(X),D2,XD2),
    delete(XD1,X,XXD1),delete(XD2,neg(X),XXD2),
    append(XXD1,XXD2,XD), list_to_set(XD,XDS),
    nsetinsets(XDS,T).

resclosed(T):-member([],T).

res(Tableau):-resclosed(Tableau),!.
res(Tableau):-
    (resrule(Tableau,NT);
    cfm(Tableau,NT)),!,res(NT).
test2res(X):-
    (   res([[neg X]])
    -> write('Proved.')
    ;  write('Disproved.')),nl.

% 4.4.7. Davis-Putnam
davput(F):-
    clauseform(neg F,CF),
    % preliminary step 1
    maplist(list_to_set,CF,CFS), % žal ne da vse v isto obliko...
    list_to_set(CFS,S1),
    % preliminary step 2
    exclude([A]>>(member(X,A),member(neg X,A)),S1,S11),
    exclude([A]>>(member(true,A)),S11,S12),
    maplist([A,B]>>delete(A,false,B),S12,S),
    davputs([S]).

davputs(S):-
    (   delete(S,[[]],[])
    ->  true,!
    ;   davput1(S,S1),!,davputs(S1)
    ).

negate(neg X,X).
negate(X,neg X):-atomic(X).

% one-literal rule
davput1(B,[R|SB]):-
    select(S,B,SB),
    select([X],S,SX),
    exclude({X}/[A]>>member(X,A),SX,SXX),
    negate(X,NX),
    maplist({X}/[A,B]>>delete(A,NX,B),SXX,R).

% Affirmative-Negative Rule
davput1(B,[R|SB]):-
    select(S,B,SB),
    member(C,S),
    member(L,C),
    \+ (member(NC,S),member(neg L,NC)),
    exclude({L}/[A]>>member(L,A),S,R).

% Subsumption Rule
davput1(B,[[C1|R]|SB]):-
    select(S,B,SB),
    select(C1,S,S1),
    select(C2,S1,R),
    subset(C1,C2).

% Splitting Rule
davput1(B,[SL,SNL|SB]):-
    select(S,B,SB),
    member(CL,S),
    member(L,CL),
    member(NCL,S),
    member(neg L,NCL),
    exclude({L}/[A]>>member(L,A),S,SL),
    exclude({L}/[A]>>member(neg L,A),S,SNL).

% unification
variable(var(_)).
partialvalue(X, Env, Y):-
    ( member([X,Z], Env)
    -> partialvalue(Z, Env, Y)
    ;  Y=X
    ).

in(X, T, Env) :-
    partialvalue(T, Env, U),
    ( X == U;
    \+ variable(U), \+ atomic(U), infunctor(X, U, Env)
    ).

infunctor(X, U, Env) :-
    U =.. [_|L],
    inlist(X, L, Env).

inlist(X, [T|_], Env) :-
    in(X, T, Env).

inlist(X, [_|L], Env) :-
    inlist(X, L, Env).

unify(Term1, Term2, Env, Newenv) :-
    partialvalue(Term1, Env, Val1),
    partialvalue(Term2, Env, Val2),
    (
    (Val1==Val2, Newenv = Env);
    (variable(Val1), \+in(Val1, Val2, Env),
        Newenv=[ [Val1, Val2] | Env] );
    (variable(Val2), \+in(Val2, Val1, Env),
        Newenv=[ [Val2, Val1] | Env] );
    (\+variable(Val1), \+variable(Val2),
        \+atomic(Val1), \+atomic(Val2),
        unifyfunctor(Val1, Val2, Env, Newenv)  )
    ),!.

unifyfunctor(Fun1, Fun2, Env, Newenv):-
    Fun1 =.. [FunSymb | Args1],
    Fun2 =.. [FunSymb | Args2],
    unifylist(Args1, Args2, Env, Newenv).

unifylist([ ], [], Env, Env).
unifylist([Head1 | Tail1], [Head2 | Tail2], Env, Newenv):-
    unify(Head1, Head2, Env, Temp),
    unifylist(Tail1, Tail2, Temp, Newenv).

% unify woth prolog variables
unify(X, Y):-
    var(X), var(Y), X=Y.
unify(X , Y) :-
    var(X), nonvar(Y), not_occurs_in(X,Y), X=Y.
unify(X,Y) :-
    var(Y), nonvar(X), not_occurs_in(Y,X), Y=X.
unify(X,Y) :-
    nonvar(X) , nonvar(Y), atomic(X), atomic(Y), X=Y.
unify(X, Y) :-
    nonvar(X), nonvar(Y),
    compound(X), compound(Y),
    term_unify(X,Y).

not_occurs_in(X,Y):-
    var(Y), X \== Y.
not_occurs_in(_,Y) :-
    nonvar(Y), atomic(Y).
not_occurs_in(X,Y) :-
    nonvar(Y), compound(Y), functor(Y,_,N),
    not_occurs_in(N,X,Y).
not_occurs_in(N,X,Y) :-
    N>0, arg(N,Y,Arg), not_occurs_in(X,Arg), N1 is N-1,
    not_occurs_in(N1,X,Y),
    not_occurs_in(0,X,Y).

term_unify(X,Y) :-
    functor(X,F,N), functor(Y,F,N), unify_args(N,X,Y).

unify_args(N,X,Y) :-
    N>0, unify_arg(N,X,Y), N1 is N-1, unify_args(N1,X,Y).
unify_args(0,_,_).
unify_arg(N,X,Y) :-
    arg(N,X,ArgX), arg(N,Y,ArgY), unify(ArgX,ArgY).

% 7.3.1.
comp(X,Y,R):-
    subs(X,Y,Z),
    exclude([A/A]>>true,Z,ZR),
    exclude({ZR}/[A]>>member([A,_],ZR),Y,YR),
    append(ZR,YR,R).

subs(X,Y,R):-
    (   member([X,Z],Y)
    ->  R=Z
    ;   X=..[H|T],
        maplist({Y}/[A,B]>>subs(A,Y,B),T,TR),
        R=..[H|TR]
    ),!.

% 7.3.2. drugič
% 7.3.3. drugič

universal(all(_,_)).
universal(neg some(_,_)).

existential(some(_,_)).
existential(neg all(_,_)).

literal(X) :-
    not conjunctive (X) ,
not disjunctive (X) ,
not unary (X) ,
not universal (X) ,
not existential(X).
