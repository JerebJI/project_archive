:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-use_module(library(yall)).

my_last(X,[X]).
my_last(X,[_|T]):-my_last(X,T).

mblast(X,[X,_]).
mblast(X,[_|T]):-mblast(X,T).

elat(H,[H|_],0).
elat(X,[_|T],K):-K>0, K1 is K-1, elat(X,T,K1).

pelat(H,[H|_],0).
pelat(X,[_|T],K):-K#>0, K1 #= K-1, pelat(X,T,K1).

len([],0).
len([_|T],N):-len(T,N1), N is N1+1.

len1(0,[]).
len1(L,[_|Ls]):-
    L#>0,
    L#=L0+1,
    len1(L0,Ls).

jug_capacity(a, 8).
jug_capacity(b, 5).
jug_capacity(c, 3).

moves(Jugs) -->
    { member(jug(a,4), Jugs),
      member(jug(b,4), Jugs) }.
moves(Jugs0) --> [from_to(From,To)],
                 { select(jug(From,FromFill0), Jugs0, Jugs1),
                   FromFill0 #> 0,
                   select(jug(To,ToFill0), Jugs1, Jugs),
                   jug_capacity(To, ToCapacity),
                   ToFill0 #< ToCapacity,
                   Move #= min(FromFill0, ToCapacity-ToFill0),
                   FromFill #= FromFill0 - Move,
                   ToFill #= ToFill0 + Move },
                 moves([jug(From,FromFill),jug(To,ToFill)|Jugs]).

pot(zelje).
pot(volk).
pot(koza).
vredu([]).
vredu([_]).
vredu([zelje,volk]).
vredu([volk,zelje]).
vredu([_,_,_]).
prm(s([],[],C)) --> {member(koza,C), member(volk,C), member(zelje, C)}.
prm(s(Z,[],K)) --> [prem(X,z,c)], {select(X,Z,Z1), vredu(Z1)}, prm(s(Z1,X,K)).
prm(s(Z,[],K)) --> [prem(X,k,c)], {select(X,K,K1), vredu(K1)}, prm(s(Z,X,K1)).
prm(s(Z,X,K))  --> [prem(X,c,z)], {pot(X), vredu([X|Z])}, prm(s([X|Z],[],K)).
prm(s(Z,X,K))  --> [prem(X,c,k)], {pot(X), vredu([X|K])}, prm(s(Z,[],[X|K])).
prm(s(Z,X,K))  --> [izm(X,Y,z)], {pot(X),select(Y,K,K1),vredu([X|K1])}, prm(s(Z,Y,[X|K1])).
prm(s(Z,X,K))  --> [izm(X,Y,k)], {pot(X),select(Y,Z,Z1),vredu([X|Z1])}, prm(s([X|Z1],Y,K)).

rev([])-->[].
rev([H|T])-->rev(T),[H].

t(n(a,n(b,nil,nil),n(c,nil,n(d,nil,nil)))).
t1(n(n(l(a),l(b)),n(n(l(c),l(d)),l(e)))).

num_leaves(Tree,N):-num_leaves_(Tree,0,N).
num_leaves_(nil,N0,N):-N#=N0+1.
num_leaves_(n(_,L,R),N0,N):-num_leaves_(L,N0,R1),num_leaves_(R,R1,N).

nleav(nil),[N]-->[N0],{N#=N0+1}.
nleav(n(_,L,R))-->nleav(L),nleav(R).

rlab(l(_),l(a)).
rlab(n(L,R),n(L1,R1)):-rlab(L,L1),rlab(R,R1).

rlev(l(_),l(N)),[N]-->[N0],{N#=N0+1}.
rlev(n(L,R),n(L1,R1))-->rlev(L,L1),rlev(R,R1).

nonv([])-->[].
nonv([0])-->[].
nonv([0|T])-->{T=[_|_]},[0],nonv(T).
nonv([0|T])-->{T=[_|_]},[0],nonv([0|T]).
nonv([H|T])-->{H#>0,H1#=H-1},[1],nonv([H1|T]).

enke(0)-->[].
enke(N)-->{N#>0,N1#=N-1},[1],enke(N1).
nicle-->[].
nicle-->[0],nicle.
nov([])-->[].
nov([X])-->nicle,enke(X).
nov([H|T])--> nicle,enke(H),[0],nov(T).
ustr(I,L,R):-length(R,L),phrase(nov(I),R).
nono(X,Y,R):-
    length(X,LX), length(Y,LY),
    maplist([A,B]>>ustr(A,LY,B),X,R),
    transpose(R,R1),
    maplist([C,D]>>ustr(C,LX,D),Y,R1).
%% prepocasi (morda ne dela), uporabi CLPB
tn([[3],[2,1],[3,2],[2,2],[6],[1,5],[6],[1],[2]], [[1,2],[3,1],[1,5],[7,1],[5],[3],[4],[3]]).

next([0|R],[1|R]).
next([1|R],[0|S]) :- next(R,S).
