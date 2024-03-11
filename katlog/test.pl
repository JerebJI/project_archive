:-use_module(library(dcg/basics)).
:-use_module(library(dcg/high_order)).
:-use_module(library(clpfd)).
:-use_module('nomads.pl').
:- set_prolog_flag(double_quotes, codes).

t("[ [ 1 1 ] [ over over + ] ; ] :fib").
t1("[ 1 ]").
t2("{as df {[a]} jk}").

conv([H|T],t(n,N)):-(code_type(H,digit);[H]="-"),number_string(N,[H|T]).
conv([H|T],t([H|T])):- \+ (code_type(H,digit),[H]="-"). %% !!!!
whsp(" \n\t").
prep(X):-whsp(Ws),append(Ws,":[]{}",X).
ws --> blanks.
token([])-->ws.
token([B|T])-->ws,"[",ws,token(B),ws,"]",token(T).
token([t(match,B)|T])-->ws,"{",ws,token(B),ws,"}",token(T).
token([t(com,A,B)|T])-->ws,{A=[_|_],prep(Pr)},string_without(Pr,A),":",{whsp(Ws)},string_without(Ws,B),token(T).
token([t(com,[],S)|T])-->ws,":",{whsp(Ws)},string_without(Ws,S),token(T).
token([R|T])-->ws,{A=[_|_],prep(Pr)},string_without(Pr,A),{conv(A,R)},ws,token(T).
popmat([],[]).
popmat([t(match,X)|T],RR):-pm(X,VY),reverse(VY,Y),append(Y,RT,RR),popmat(T,RT).
popmat([t(com,A,B)|T],[t(match(t(com,A,B)))|RT]):-popmat(T,RT).
pm([],[]).
pm([t(match,X)|T],[X|RT]):-pm(T,RT).
pm([t(com,X)|T],[t(match,t(com,X))|RT]):-pm(T,RT).
pm([t(X)|T],[t(match,t(X))|RT]):-pm(T,RT).
pm([t(n,X)|T],[t(match,t(n,X))|RT]):-pm(T,RT).

% več skladov (dodaj še vstavljanje skladov)
dop(s(X,_,_),L,L):-member(s(X,_,_),L).
dop(s(X,_,_),L,[s(X,[],[])|L]):- \+ member(s(X,_,_),L). %% !!!!
push_(Kaj,s(C,Pr,Po),s(C,Pr,[Kaj|Po])).
pop_(Izh,s(C,Pr,[Izh|Po]),s(C,Pr,Po)).
pop_(Izh,s(C,Pr,[]),s(C,[Izh|Pr],[])).
pusht(Kaj,env(Curr,S),env(Curr,[X|S1])):-dop(s(Curr,_,_),S,Sd),select(s(Curr,Pr,Po),Sd,S1),
                                       push_(Kaj,s(Curr,Pr,Po),X).
popt(Kaj,env(Curr,S),env(Curr,[X|S1])):-dop(s(Curr,_,_),S,Sd),select(s(Curr,Pr,Po),Sd,S1),
                                      pop_(Kaj,s(Curr,Pr,Po),X).
int(O,env(Curr,X),env(NC,X)):-append(Curr,O,NC).
outt(O,env(Curr,X),env(NC,X)):-append(NC,O,Curr).

:-nomad(env, [push,pop,in,out], env("",[])).
:-nomad_method(push(X), Old, New, pusht(X,Old,New)).
:-nomad_method(pop(X), Old, New, popt(X,Old,New)).
:-nomad_method(in(X), Old, New, int(X,Old,New)).
:-nomad_method(out(X), Old, New, outt(X,Old,New)).
:-nomad_pred(ev/1, [env]).

oeval(P):-peval(P,R),phrase(izpisi(R),O),format("~s",[O]).
peval(P,R):-phrase(token(PP),P),eval(PP,R).
eval(P,R):--( ev(P) ) with (env(R)).
% osnovno
ev([]) :-- true.
ev([[X]|T]) :-- env::push(X), ev(T).
ev([t(match,[X])|T]) :-- env::pop(X),  ev(T).
% upravljanje sklada
ev([t("swap")|T]):-- env::pop(X), env::pop(Y), env::push(X), env::push(Y), ev(T).
ev([t("dup")|T]):-- env::pop(X), env::push(X), env::push(X), ev(T).
ev([t("rot")|T]):-- env::pop(X), env::pop(Y), env::pop(Z),
                    env::push(Y), env::push(X), env::push(Z),ev(T).
ev([t("over")|T]):--env::pop(X), env::pop(Y), env::push(Y), env::push(X), env::push(Y), ev(T).
ev([t("drop")|T]):--env::pop(_),ev(T).
ev([t("_")|T]):--env::push(_),ev(T).
% visje nivojsko programiranje
ev([t("quote")|T]):--env::pop(X), env::push([X]), ev(T).
ev([t("unquote")|T]):--env::pop(X), append(X,T,XT), ev(XT).
% ali
ev([t(";")|T]):--env::pop(X),env::pop(Y),(append(X,T,RT);append(Y,T,RT)),ev(RT).
% osnovne operacije s seznami
ev([t("qhead")|T]):--env::pop([H|_]),env::push([H]),ev(T).
ev([t("head")|T]):--env::pop([H|_]),ev([H]),ev(T).
ev([t("tail")|T]):--env::pop([_|TT]),env::push(TT),ev(T).
ev([t(",")|T]):--env::pop(X),env::pop(Y),append(Y,X,YX),env::push(YX),ev(T).
% osnovne stevilske operacije
ev([t(n,N)|T]):--env::push(t(n,N)),ev(T).
ev([t("+")|T]):--env::pop(t(n,X)),env::pop(t(n,Y)),X+Y#=Z,env::push(t(n,Z)),ev(T).
ev([t("..")|T]):--env::pop(t(n,X)),env::pop(t(n,Y)),env::pop(t(n,Z)),X in Y..Z,env::push(t(n,X)),ev(T).
ev([t("")|T]):--ev(T).
ev([t(push,K)|T]):--env::pop(X),env::in(K),env::push(X),env::out(K),ev(T).
ev([t(com,A,B)|T]):--env::in(A),ev([B]),env::out(A),ev(T).
ev([t(X)|T]):--env::value(env(_,S)),member(s(X,_,_),S),
               env::in(X),env::pop(U),env::push(U),env::out(X),ev(U),ev(T).
ev([t("")|T]):--ev(T).

izpisi(env(_,S))-->izpisi(S).
izpisi([s(Ime,Pr,Po)|T])-->Ime,":\n\t",izps(Pr),"\n\t",izps(Po),"\n",izpisi(T).
izpisi([])-->[].
%izps(X)-->{format(string(Y),'~q',[X])},Y.
izps([X|T])-->{X=[_|_];X=[]},"[",izps(X),"]",izps(T).
izps([t(X)|T])-->" ",X,izps(T).
izps([[t(A)|TT]|T])-->" ",izpt([t(A)|TT]),izps(T).
izps([t(n,N)|T])-->{label([N]),number_string(N,I)}," ",I,izps(T).
izps([])-->"".
izpt([t(X)|T])-->X," ",izpt(T).
izpt([t(n,X)|T])-->{label([X]),number_string(N,X)},N," ",izpt(T).
izpt([])-->" ".

% pregledati moram quotation v Joy (kjer je vsebina quota drugacna)
