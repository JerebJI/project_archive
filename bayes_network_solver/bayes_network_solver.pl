:- use_module(library(lists)).
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).
:- use_module(library(apply)).
:- table solve/4.

% Bayes network solver
% input: bayes network, which probability to express
% output: solution steps

% test cases (try: test.)
data([a-c,c-e,b-d,d-f,d-e,e-g,g-h,g-i]).
query([c]/[]). query([g]/[c,d]). query([g]/[c,i]). query([d]/[e,f]).
test :- data(D), query(Q), solve_query(Q,D).

solve_query(Q,D):-phrase(solve(Q,D),R),unnest(R,[[Q]],U),list_to_set(U,SU),convert(SU,S),format('~w',[S]).
% solve query with iterative deepening
solve_query_id(Q,D):-length(R,_),phrase(solve(Q,D),R),unnest(R,[[Q]],U),list_to_set(U,SU),convert(SU,S),format('~w',[S]).
solve([]/[],_) --> []. % truth
solve(X/C,_) --> [taut], {subset(X,C),!}. % tautology
% contradiction
solve(M/C,_)--> [contra],{member(X,M),atom(X),member(not(X),C),!}.
solve(M/C,_)--> [contra],{member(not(X),M),atom(X),member(X,C),!}.
% given with the bayes network
solve([X]/[],D)--> [known], % special case (start of the network)
    {atom(X),member(X-_,D),\+member(_-X,D),!}.
solve([M]/C,D)-->[known],
    {atom(M),parents(M,Ps,D),getNs(Ns,C),permutation(Ns,Ps),!}.
solve([not(X)]/C,D)-->{atom(X)},[unnot([X]/C)],solve([X]/C,D),{!}. % 1-P
solve([X]/C,D)--> % rule 6a
    {atom(X),no_parent(X,C,D),\+member(_-X,D)},[r6a([X]/[])],
    solve([X]/[],D),{!}.
solve([H|T]/C,D)-->[konj([X]/C,[RH|RT]/S)], % conjunction
    {select(X,[H|T],[RH|RT]),list_to_set([X|C],S)},
    solve([X]/C,D),solve([RH|RT]/S,D).
solve([X]/C,D)--> [bayes([X]/R,[Y]/SY,[Y]/CY)], % bayes rule
    {atom(X),select(Y,C,R),member(X-Y,D),list_to_set([X|C],S),
    subtract(S,[Y],SY), subtract(C,[Y],CY)},
    solve([X]/R,D), solve([Y]/SY,D), solve([Y]/CY,D).
solve([X]/C,D)-->[r6b(X,SVs)], % rule 6b
    {parents(X,Ps,D),combs(Ps,Cs)},r6b_solve(C,Cs,D,SVs).
% helper predicate for rule 6b
r6b_solve(_,[],_,[])-->[].
r6b_solve(C,[S|T],D,[S/C|ST])-->{phrase(solve(S/C,D),R)},uroll(R),r6b_solve(C,T,D,ST).
% insert array into array (DCG predicate) (to circumvent playground restrictions)
uroll([])-->[].
uroll([H|T])-->[H],uroll(T).
% "parents" of a node in bayes network
parents(N,Ps,D):-findall(P,member(P-N,D),Ps).
% test if node has no parent
no_parent(_,[],_).
no_parent(X,[H|T],D):- \+ member(X-H,D), no_parent(X,T,D).
getNs(Ns,D):-findall(N,((member(N,D);member(not(N),D)),atom(N)),Ls),list_to_set(Ls,Ns).
% all combinations of truth values
comb([],[]).
comb([PH|PT],[PH|CT]):-comb(PT,CT).
comb([PH|PT],[not(PH)|CT]):-comb(PT,CT).
combs(X,Cs):-findall(C,comb(X,C),Cs).
% convert "stack proof code" into blocks of formulas
unnest([],L,L).
unnest([known|T],        [H|IT], [[known|H]|R])        :- unnest(T,IT,R).
unnest([taut|T],         [H|IT], [[taut|H]|R])         :- unnest(T,IT,R).
unnest([contra|T],       [H|IT], [[contra|H]|R])       :- unnest(T,IT,R).
unnest([unnot(X)|T],     [H|IT], [[unnot(X)|H]|R])     :- unnest(T,[[X]|IT],R).
unnest([r6a(X)|T],       [H|IT], [[r6a(X)|H]|R])       :- unnest(T,[[X]|IT],R).
unnest([konj(X,Y)|T],    [H|IT], [[konj(X,Y)|H]|R])    :- unnest(T,[[X],[Y]|IT],R).
unnest([bayes(X,Y,Z)|T], [H|IT], [[bayes(X,Y,Z)|H]|R]) :- unnest(T,[[X],[Y],[Z]|IT],R).
unnest([r6b(X,Cs)|T],    [H|IT], [[r6b(X,Cs)|H]|R]) :-
    pack(Cs,PCs),append(PCs,IT,PIT),unnest(T,PIT,R).
% helper function
pack(X,Y):-maplist(pck,X,Y).
pck(X,[X]).
% convert X/C into string
xc_p(X/[],R):- % special case (P(X|)=P(X))
    phrase(foreach(member(SX,X),atom(SX),","),RX),
    format(string(R),'P(~s)',[RX]),!.
xc_p(X/C,R):-
    phrase(foreach(member(SX,X),atom(SX),","),RX),
    phrase(foreach(member(SC,C),atom(SC),","),RC),
    format(string(R),'P(~s | ~s)',[RX,RC]),!.
% blocks of formulas into string
convert(U,S):-maplist(conv,U,CU),reverse(CU,RCU),foldl(concnl,RCU,"",S).
% convert formula into string
conv(L,S):-reverse(L,RL),to_string(RL,SL),reverse(SL,RSL),foldl(string_concat,RSL,"",S).
concnl(A,B,R):-string_concat(A,"\n",R1),string_concat(R1,B,R). % concat with newlines
% convert "tactics/commands" into string
to_string([],[]).
to_string([X/C|T],[P|R]):-xc_p(X/C,P),to_string(T,R).
to_string([known],[" known"]).
to_string([taut],[" tautology (2)"]).
to_string([contra],[" contradiction (3)"]).
to_string([unnot(X/C)|T],[S|R]):-xc_p(X/C,P),format(string(S),' =[4]= 1 - ~s',[P]),to_string(T,R).
to_string([r6a(X/C)|T],[S|R]):-xc_p(X/C,P),format(string(S),' =[6a]= ~s',[P]),to_string(T,R).
to_string([konj(X,Y)|T],[S|R]):-xc_p(X,PX),xc_p(Y,PY),
    format(string(S),' =[1]= ~s * ~s',[PX,PY]),to_string(T,R).
to_string([bayes(X,Y,Z)|T],[S|R]):-xc_p(X,PX),xc_p(Y,PY),xc_p(Z,PZ),
    format(string(S),' =[5]= ~s * ~s / ~s',[PX,PY,PZ]),to_string(T,R).
to_string([r6b(X,Cs)|T],[S|R]):-r6b_str(X,Cs,P),
    format(string(S),' =[6b]= ~s',[P]),to_string(T,R).
r6b_str(X,[S/C],R):-xc_p(S/C,SC),xc_p([X]/S,XS),format(string(R),'~s*~s',[XS,SC]).
r6b_str(X,[S/C|T],P):-r6b_str(X,T,R),xc_p([X]/S,XS),xc_p(S/C,SC),
    format(string(P),'~s*~s + ~s',[XS,SC,R]).
