:-use_module(library(dcg/basics)).
:-use_module(library(dcg/high_order)).
:-use_module(library(clpfd)).
:-use_module('nomads.pl').
:- set_prolog_flag(double_quotes, codes).

t("[ [ 1 1 ] [ over over + ] ; ] :fib").
t1("[ 1 ]").

whsp(" \n\t").
prep(X):-whsp(Ws),append(Ws,":[]{}",X).
ws --> blanks.
token([])-->ws.
token([[B]|T])-->ws,"[",ws,token(B),ws,"]",token(T).
token([match(B)|T])-->ws,"{",ws,token(B),ws,"}",token(T).
token([com(A,B)|T])-->ws,{A=[_|_],prep(Pr)},string_without(Pr,A),":",{whsp(Ws)},string_without(Ws,B),token(T).
token([push(S)|T])-->ws,":",{whsp(Ws)},string_without(Ws,S),token(T).
token([t(A)|T])-->ws,{A=[_|_],prep(Pr)},string_without(Pr,A),ws,token(T).

% ne vem zakaj dela veliko slabše kot token
lit([X|T]) --> {code_type(X,csym);member(X,":;[]{}+-*/'?.,!\"#$%&<>=^")},[X],lit(T).
lit([])-->"".
tok(T)-->blanks,tok_(B),lit(L),blanks,{append(B,[t(L)],T)}.
tok_([t(B)|T])-->{B=[_|_]},lit(B),blank,blanks,tok_(T).
tok_([])-->blanks.

% "logični sklad"
push_(Kaj,s(Pr,Po),s(Pr,[Kaj|Po])).
pop_(Izh,s(Pr,[Izh|Po]),s(Pr,Po)).
pop_(Izh,s(Pr,[]),s([Izh|Pr],[])).
izoko_(_,X,X).
voko_(_,X,X).
% več skladov (dodaj še vstavljanje skladov)
dop(s(X,_,_),L,L):-member(s(X,_,_),L).
dop(s(X,_,_),L,[s(X,[],[])|L]):- \+ member(s(X,_,_),L). %% !!!!
pusht_(Kaj,s(C,Pr,Po),s(C,Pr,[Kaj|Po])).
popt_(Izh,s(C,Pr,[Izh|Po]),s(C,Pr,Po)).
popt_(Izh,s(C,Pr,[]),s(C,[Izh|Pr],[])).
pusht(Kaj,ok(Curr,S),ok(Curr,[X|S1])):-dop(s(Curr,_,_),S,Sd),select(s(Curr,Pr,Po),Sd,S1),pusht_(Kaj,s(Curr,Pr,Po),X).
popt(Kaj,ok(Curr,S),ok(Curr,[X|S1])):-dop(s(Curr,_,_),S,Sd),select(s(Curr,Pr,Po),Sd,S1),popt_(Kaj,s(Curr,Pr,Po),X).
vokot(O,ok(Curr,X),ok(NC,X)):-append(Curr,O,NC).
izokot(O,ok(Curr,X),ok(NC,X)):-append(NC,O,Curr).

:-nomad(okolje, [pushs,pops,voko,izoko], ok("",[])).
:-nomad_method(pushs(X), Old, New, pusht(X,Old,New)).
:-nomad_method(pops(X), Old, New, popt(X,Old,New)).
:-nomad_method(voko(X), Old, New, vokot(X,Old,New)).
:-nomad_method(izoko(X), Old, New, izokot(X,Old,New)).
:-nomad_pred(ev/1, [okolje]).

oeval(P):-peval(P,R),phrase(izpisi(R),O),format("~s",[O]).
peval(P,R):-phrase(token(PP),P),eval(PP,R).
eval(P,R):--( ev(P) ) with (okolje(R)).
% osnovno
ev([]) -->> true.
ev([[X]|T]) :-- okolje::pushs(X), ev(T).
ev([match(X)|T]) :-- okolje::pops(X),  ev(T).
% upravljanje sklada
ev([t("swap")|T]):-- okolje::pops(X), okolje::pops(Y), okolje::pushs(X), okolje::pushs(Y), ev(T).
ev([t("dup")|T]):-- okolje::pops(X), okolje::pushs(X), okolje::pushs(X), ev(T).
ev([t("rot")|T]):-- okolje::pops(X), okolje::pops(Y), okolje::pops(Z),
                    okolje::pushs(Y), okolje::pushs(X), okolje::pushs(Z),ev(T).
ev([t("over")|T]):--okolje::pops(X), okolje::pops(Y), okolje::pushs(Y), okolje::pushs(X), okolje::pushs(Y), ev(T).
ev([t("drop")|T]):--okolje::pops(_),ev(T).
ev([t("_")|T]):--okolje::pushs(_),ev(T).
% visje nivojsko programiranje
ev([t("quote")|T]):--okolje::pops(X), okolje::pushs([X]), ev(T).
ev([t("unquote")|T]):--okolje::pops(X), append(X,T,XT), ev(XT).
% ali
ev([t(";")|T]):--okolje::pops(X),okolje::pops(Y),(append(X,T,RT);append(Y,T,RT)),ev(RT).
% osnovne operacije s seznami
ev([t("qhead")|T]):--okolje::pops([H|_]),okolje::pushs([H]),ev(T).
ev([t("head")|T]):--okolje::pops([H|_]),ev([H]),ev(T).
ev([t("tail")|T]):--okolje::pops([_|TT]),okolje::pushs(TT),ev(T).
ev([t(",")|T]):--okolje::pops(X),okolje::pops(Y),append(Y,X,YX),okolje::pushs(YX),ev(T).
% osnovne stevilske operacije
ev([t(N)|T]):--number_string(I,N),okolje::pushs(I),ev(T).
ev([t("+")|T]):--okolje::pops(X),okolje::pops(Y),X+Y#=Z,okolje::pushs(Z),ev(T).
ev([t("")|T]):--ev(T).
ev([push(K)|T]):--okolje::pops(X),okolje::voko(K),okolje::pushs(X),okolje::izoko(K),ev(T).
ev([com(A,B)|T]):--okolje::voko(A),ev([B]),okolje::izoko(A),ev(T).
ev([t(X)|T]):--okolje::value(ok(_,S)),member(s(X,_,_),S),
               okolje::voko(X),okolje::pops(U),okolje::pushs(U),okolje::izoko(X),ev(U),ev(T).
ev([t("")|T]):--ev(T).

izpisi(ok(_,S))-->izpisi(S).
izpisi([s(Ime,Pr,Po)|T])-->Ime,":\n\t",izps(Pr),"\n\t",izps(Po),"\n",izpisi(T).
izpisi([])-->[].
%izps(X)-->{format(string(Y),'~q',[X])},Y.
izps([X|T])-->{X=[_|_];X=[]},"[",izps(X),"]",izps(T).
izps([[t(A)|TT]|T])-->" ",izpt([t(A)|TT]),izps(T).
izps([N|T])-->{number_string(N,I)}," ",I,izps(T).
izps([])-->"".
izpt([t(X)|T])-->X," ",izpt(T).
izpt([])-->"".

% pregledati moram quotation v Joy (kjer je vsebina quota drugacna)
% oeval("3 {3}"). oeval("{3}").
