:- dynamic(natnum/1).
natnum(0).
natnum(s(X)):-natnum(X).

mi1(true).
mi1((X,Y)):-mi1(X), mi1(Y).
mi1(G):- G\=true, G\=(_,_), clause(G,B), mi1(B).

:-dynamic(natnum2/1).
natnum2(0).
natnum2(s(X)):- +natnum2(X).
+G :- G.
mi2(true).
mi2((X,Y)):-mi2(X),mi2(Y).
mi2(+G):- G\=true,G\=(_,_), clause(G,B), mi2(B).

miclause(G,B):-clause(G,B1),def_mi(B1,B).
def_mi(true,true).
def_mi((X,Y),(A,B)):-def_mi(X,A),def_mi(Y,B).
def_mi(G,+G):-G\=true,G\=(_,_).

mi_list(natnum(0), []).
mi_list(natnum(s(X)), [natnum(X)]).

mi3([]).
mi3([H|T]):-mi_list(H,B),mi3(B),mi3(T).

mi_list1(natnum(0),R,R).
mi_list1(natnum(s(X)),[natnum(X)|R],R).

mi4([]).
mi4([H|T]):-mi_list1(H,R,T),mi3(R).
