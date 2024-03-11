:- use_module( './nomads/nomads.pl' ).
:- use_module(library(clpfd)).
:- set_prolog_flag(double_quotes, codes).

:- nomad( stack, [push,pop], [] ).

:- nomad_method( push(X), Old, New, New = [X|Old] ).
:- nomad_method( pop(X),  Old, New, Old = [X|New] ).

:- nomad_pred( expression/0,   [stack,dcg] ).
:- nomad_pred( term/0,         [stack,dcg] ).
:- nomad_pred( factor/0,       [stack,dcg] ).


eval(Exp,Result) :--
( expression, stack::pop(Result) ) with (dcg(Exp),stack).

expression -->> term, [+], expression,
stack::pop(X), % The expression.
stack::pop(Y), % The term.
Result is X + Y,
stack::push(Result).
expression -->> term.

term -->> factor, [*], term,
stack::pop(X), % The term.
stack::pop(Y), % The factor.
Result is X * Y,
stack::push(Result).
term -->> factor.

factor -->> ['('], expression, [')'].
factor -->> [X], number(X), stack::push(X).

:-nomad(errs, [add], []).
:-nomad_method(add(X), Old, New, New=[X|Old]).
:-nomad_method(sub(X), Old, New, Old=[X|New]).
:-nomad(pos, [inc], 0).
:-nomad_method(inc, Old, New, New#=Old+1).
:-nomad(sens, [add], []).
:-nomad(mark, [add,sub], []).
:-nomad_pred(n/1, [pos,mark,sens,errs,dcg]).
:-nomad_pred(a/1, [pos,mark,sens,errs,dcg]).
:-nomad_pred(np/0, [pos,mark,sens,errs,dcg]).
:-nomad_pred(v/0, [pos,mark,sens,errs,dcg]).
:-nomad_pred(svo/0, [pos,mark,sens,errs,dcg]).
:-nomad_pred(bv/1, [pos,mark,sens,errs,dcg]).
:-nomad_pred(err/1, [pos,mark,sens,errs,dcg]).
:-nomad_pred(ok/1, [pos,mark,sens,errs,dcg]).
:-nomad_pred(m/0, [pos,mark,sens,errs,dcg]).

slovn(Exp,S,E) :-- ( svo ) with (dcg(Exp),mark,sens(S),errs(E),pos).

ok(X) -->> mark::sub(Z), pos::value(K), sens::add(ok(X,Z,K)).
m -->> pos::value(V), mark::add(V).
bv(X) -->> sens::add(X), pos::inc.
err(X) -->> mark::sub(Z), pos::value(P), errs::add(napaka(X,Z,P)).
n(m) -->> "maček", bv(n("maček")).
n(z) -->> "mačka", bv(n("mačka")).
a(m) -->> "debel", bv(a("debel")).
a(z) -->> "debela", bv(a("debela")).
v -->> "je", bv(v("je")).
np -->> m,a(X), " ", n(X), ok(np(2)).
np -->> m,n(_), ok(np(1)).
np -->> m,{dif(X,Y)}, a(X), " ", n(Y), err(neujemanje_spolov).
np -->> m,n(_), " ", a(_), err(napacni_vrstni_red_sam_prid).
np -->> m,n(_), " ", n(_), err(zaporedna_samostalnika).
svo -->> m,np, " ", np, err(manjka_glagol).
svo -->> m,np, " ", v, " ", np, ok(svo(3)).

tree(svo(Z,K,S,V,O))-->okt(svo(3),Z,K),npt(S),vt(V),npt(O).
okt(X,Z,K)-->[ok(X,Z,K)].
npt(np(Z,K,a(A),n(N)))-->okt(np(2),Z,K), [n(N), a(A)].
npt(np(Z,K,n(N)))-->okt(np(1),Z,K),[n(N)].
vt(v(V))-->[v(V)].
