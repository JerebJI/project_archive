:-use_module(library(dcgs)).
:-use_module(library(lists)).
:-use_module(library(charsio)).
:-use_module(library(format)).
:-use_module(library(dif)).

% deluje s scryer prolog, NE deluje s swi prologom (ne vem zakaj)

% Testni primeri
t1([n("Hva"),n("li"),n("te "),n("Go"),p("spo"),n("da "),n("ne"),p("be"),n("sa "),t(kv),n("hva"), n("li"), n("te "), n("ga "), n("na "), n("vi"), p("ša"), n("vah"),t(kv)]).
t2([n("Ne "), n("za"), n("vrzi "), p("svo"), n("jega "), n("ma"), p("zi"), n("ljen"), n("ca "), t(kv), n("za"), n("ra"), n("di "), n("Da"), n("vi"), n("da "), n("svo"), n("je"), n("ga "), n("slu"), p("ža"), n("bni"), n("ka"),t(kv)]).

% osnovne vrste zlogov
n(pn,_) --> [].
n(n,X)  --> [n(X)].
n(p,X)  --> [p(X)].
n(s,X)  --> [s(X)].
n(kn,X) --> [n(_,X)];[n(X)];[s(X)];[p(X)].
n(T,X)  --> [n(T,X)].
% orodja za sestavo tonovskih nacinov
t(n(T,V,D),n(T,V,D)).
t(t(kv),t(kv)).
t(pon(X),rep(ned,S)):-sk(X,S).
% deli tonovskih nacinov
t(b(X),vz(ned,n(kn,X,b))).
t(uv1,[n(kn,f,c),pov([n(kn,g,c),n(kn,a,c)])]).
t(uv2,[n(kn,c,c),n(kn,d,c)]).
t(uv3,[n(kn,g,c),pov([n(kn,a,c),n(kn,b,c)])]).
t(uv4,[n(kn,a,c),pov([n(kn,g,c),n(kn,a,c)])]).
t(uv5,[n(kn,f,c),n(kn,a,c)]).
t(uv7,[pov([n(kn,c,c),n(kn,b0,c)]),pov([n(kn,c,c),n(kn,d,c)])]).
t(uv8,[n(kn,g,c),n(kn,a,c)]).
t(uvd,[n(kn,d,c),pov([n(kn,c,c),n(kn,d,c)])]).
t(uvp,[pov([n(kn,a,c),n(kn,es(b),c)])]).
t(pk1,[n(p,es(b),c),o(n(kn,a,c)),n(kn,a,c),n(p,g,c),o(n(kn,a,c)),n(kn,a,cp)]).
t(pk2,[n(p,g,c),o(n(kn,f,c)),n(kn,f,cp)]).
t(pk3,[n(p,d1,c),o(n(kn,c1,c)),n(kn,c1,c),zam(t,p,[o(n(kn,c1,c)),pov([n(kn,b,c),n(kn,a,c)])]),n(kn,c1,cp)]).% ne dela !!
t(pk4,[n(kn,g,c),n(kn,a,c),n(p,b,c),o(n(kn,a,c)),n(kn,a,cp)]).
t(pk5,[n(p,d1,c),o(n(kn,c1,c)),n(kn,c1,cp)]).
t(pk6,[n(kn,g,c),n(p,a,c),o(n(kn,f,c)),n(kn,f,cp)]).
t(pk7,[n(p,f,c),o(n(kn,e,c)),n(kn,e,c),n(p,d,c),o(n(kn,e,c)),n(kn,e,cp)]).
t(pk8,[n(p,d1,c),o(n(kn,c1,c)),n(kn,c1,cp)]).
t(pkc,[n(kn,b,c),n(kn,a,c),n(p,c1,c),o(n(kn,c1,c)),n(kn,c1,cp)]).
t(pkd,[n(kn,c,c),n(kn,d,c),n(p,e,c),o(n(kn,d,c)),n(kn,d,cp)]).
t(pke,[n(p,g,c),o(n(kn,f,c)),n(kn,f,cp)]).
t(pkp,[n(p,g,c),n(kn,es(b),c),n(kn,a,c),n(p,g,c),o(n(kn,f,c)),n(kn,f,cp)]).
t(sk1,[n(kn,g,c),n(kn,f,c),n(p,g,c),o(n(kn,a,c)),n(kn,a,cp)]).
sk(X,Y):-maplist(t,X,Y).
% tonovski nacini
tn(o1a,S):-sk([uv1,pon([b(a),pk1,t(kv),ba,sk1,t(kv)])],S).
% parckanje zlogov
% ton(TonovskiNacin, Omilitve, Rezultat)
% n(T,V,D) - nota tipa T, visine V in dolzine D
% [...] - blok kode, ali([...]) - poparckaj z enim od [...]
% pn - ignoriraj, t(X) - token t(X), in([...]) - akord
% pon([...]) - note povezane z lokom, o(X) - ali([X,pn])
% rep(K,X) - K-krat poparckaj X (ned 0+)
% vz(K,X) - isto kot rep, samo da se zlogi zdruzijo in ned je 1+
% zam(T,X,Y) - zamenjaj en element Y tipa T (t-tip note,v-visina,d-dolzina) za X
ton(Tn,O,R) --> {tn(Tn,P)}, ton_(O,P,R).
ton_(O,[[H|T]|T2],R) --> ton_(O,[H|T],R1), ton_(O,T2,R2), {append(R1,R2,R)}.
ton_(O,[n(T,V,D)|Ns],[z(Z,V,D,T)|R]) --> n(T,Z), ton_(O,Ns,R).
ton_(O,[ali([H|_])|Ns],R) --> ton_(O,[H],R1), ton_(O,Ns,R2), {append(R1,R2,R)}.
ton_(O,[ali([_,A|T])|Ns],R) --> ton_(O,[ali([A|T])|Ns],R).
ton_(O,[pn|Ns],R) --> ton_(O,Ns,R).
ton_(O,[t(X)|Ns],R) --> [t(X)], ton_(O,Ns,R).
ton_(O,[in([n(T,V,D)|IT])|Ns], [[n(Z,V,D)|IT]|R]) --> n(T,Z), ton_(O,Ns,R).
ton_(O,[pov([n(T,V,D)|IT])|Ns], [pov(Z,[n(T,V,D)|IT])|R]) --> n(T,Z), ton_(O,Ns,R).
ton_(O,[o(X)|Ns],R) --> ton_(O,[ali([X,pn])|Ns],R).
ton_(O,[rep(ned,X)|Ns],R)  --> ton_(O,[X],R1), ton_(O,[rep(ned,X)|Ns],R2), {append(R1,R2,R)}.
ton_(O,[rep(ned,_)|Ns],R)  --> ton_(O,Ns,R).
ton_(O,[rep(s(X),Y)|Ns],R) --> ton_(O,[Y],R1), ton_(O,[rep(X,Y)|Ns],R2), {append(R1,R2,R)}.
ton_(O,[rep(0,_)|Ns],R) --> ton_(O,Ns,R).
ton_(O,[zam(T,X,Y)|Ns],R) --> {zam(T,X,Y,Z)}, ton_(O,[Z|Ns],R).
ton_(O,[vz(K,X)|Ns],[vz(T,X)|R])  --> vz(K,[X],T), ton_(O,Ns,R).
ton_(_,[],[])-->[].
% omilitve
% izm(T,K,X) - razumi objekte z lastnostjo T, ki je enaka K, za X
% vzl(N,T,K) - objekte z lastnostjo T, ki je enaka K, sprejme N zlogov (po vz pravilih)
ton_(O,[H|Ns],R) --> {member(izm(T,K,X),O),izb(T,K,H),zame(T,X,H,HS)}, ton_(O,[HS|Ns],R).
ton_(O,[H|Ns],R) --> {member(vzl(N,T,K),O),izb(T,K,H)}, ton_(O,[vz(N,H)|Ns],R).

% ton_ samo le za n(...) in [...]
samn([[H|T]|Ns],R) --> samn([H|T],R1), samn(Ns,R2), {append(R1,R2,R)}.
samn([n(T,_,_)|Ns],R) --> n(T,R1), samn(Ns,R2), {append(R1,R2,R)}.
samn([],"") --> [].
% implementacija vz
vz(ned,X,R)  --> samn(X,R1), vz(ned,X,R2), {append(R1,R2,R)}.
vz(ned,X,R)  --> samn(X,R).
vz(s(K),X,R)  --> samn(X,R1), vz(K,X,R2), {append(R1,R2,R)}.
vz(0,_,[]) --> [].
% izbere lastnost n(...)
izb(t,K,n(K,_,_)).
izb(v,K,n(_,K,_)).
izb(d,K,n(_,_,K)).
izb(n,K,K).
% zamenja lastnost n(...) za en element
zame(t,X,n(_,V,D),n(X,V,D)).
zame(v,X,n(T,_,D),n(T,X,D)).
zame(d,X,n(T,V,_),n(T,V,X)).
zame(n,X,_,X).
% zamenja lastnost za več elementov
zam(T,X,[H|R],[ZH|R]):-zame(T,X,H,ZH).
zam(T,X,[H|T1],[H|T2]):-zam(T,X,T1,T2).

% TODO: tail rec, osnovne_omilitve(X)

% Pomocnik za zloge
% vsi znaki
zna(sam,[X]) --> {member(X,"aeiou"); member(X,"AEIOU")}, [X].
zna(zvo,[X]) --> {member(X,"mnrlvj"); member(X,"MNRLVJ")}, [X].
zna(zve,[X]) --> {member(X,"bdgzž"); member(X,"BDGZŽ")}, [X].
zna(nez,[X]) --> {member(X,"ptksšcčhf"); member(X,"PTKSŠCČHF")}, [X].
zna(dru,[X]) --> {member(X,"wxyq"); member(X,"WXYQ")}, [X].
zna(sog,X) --> zna(zvo,X) ; zna(zve,X) ; zna(nez,X) ; zna(dru,X).
zna(loc,[X]) --> {member(X,",.-';:()")}, [X].
sam(X) --> zna(sam,X).
sog(X) --> zna(sog,X).
opc(K,X) --> zna(K,X).
opc(_,"") --> [].
ws([W|Ws]) --> [W], {char_type(W,whitespace)}, ws(Ws).
ws([]) --> "".
loc("") --> [].
loc(" ") --> ws(X), {dif(X,"")}.
loc(X) --> zna(loc,X).
loc(R) --> zna(loc,X), ws(W), {dif(W,""), append(X," ",R)}.
% "zlog"
zlog(R) --> sog(A), opc(sog,B), opc(sog,C), opc(sam,D), sam(E), opc(sog,F), opc(sog,G), loc(H),
            { foldl(append,[H,G,F,E,D,C,B,A],[],R) }.
zlog(R) --> sam(E), opc(sog,F), opc(sog,G), loc(H),
            { foldl(append,[H,G,F,E],[],R) }.
zlog(R) --> sog(R), " ".
zlog(R) --> "(", zlog(X), {append("(",X,R)}.
zlog(R) --> sog(A), sog(B), sog(C), opc(sog,D), loc(E), { foldl(append,[E,D,C,B,A],[],R) }.
zlogi([H|T]) --> zlog(H), zlogi(T).
zlogi([]) --> [].
vsiZlogi(V,R):-setof(X,phrase(zlogi(X),V),R).
% pretvori seznam zlogov v tekst
vtekst([H|T]) --> "-", H, vtekst(T).
vtekst([]) --> "".
zlg([H|T]) --> {member(H,"qwertzuiopšasdfghjklčžyxcvbnmQWERTZUIOPŠASDFGHJKLČŽYXCVBNM,.;:() ")}, [H], zlg(T).
zlg([]) --> "".
% pretvori vhod zlogov v pravo obliko
urejZlogi([n(n,X)|T]) --> "-", zlg(X), urejZlogi(T).
urejZlogi([n(p,X)|T]) --> "+", zlg(X), urejZlogi(T).
urejZlogi([t(kv)|T]) --> "*", urejZlogi(T).
urejZlogi([n(O,X)|T]) --> "_", [O], "_", zlg(X), {dif(X,[])}, urejZlogi(T).
urejZlogi([k]) --> [].

%% ZA LAZARUS PROGRAM
%ugibajZloge(T):-phrase(zlogi(R),T),phrase(vtekst(R),I),format("~s",[I]),halt.
%izhod(Z,T):-phrase(urejZlogi(R),Z),phrase(ton(T,[],U),R),format("~q",[U]),halt.

% TODO: morda se pretvoriti v notno obliko

% Lilypond (ne dela za in(...)) (ima prehajanje v novo vrstico glede na stevilo v omej (15))
lt([z("Hva",f,c,kn),pov("li",[n(kn,g,c),n(kn,a,c)]),vz("te Go",n(kn,a,b)),z("spo",b,c,p),z("da ",a,c,kn),z("ne",a,c,kn),z("be",g,c,p),z("sa ",a,cp,kn),vz("hvalite g ...",n(kn,a,b)),z("na ",g,c,kn),z("vi",f,c,kn),z("ša",g,c,p),z("vah",a,cp,kn)]).
visLil(es(X),R):-visLil(V),append(V,"",R). visLil(is(X),R):-visLil(V),append(V,"",R).
visLil(c0,"c"). visLil(d0,"d"). visLil(e0,"e"). visLil(f0,"f"). visLil(g0,"g"). visLil(a0,"a"). visLil(b0,"b").
visLil(c,"c'"). visLil(d,"d'"). visLil(e,"e'"). visLil(f,"f'"). visLil(g,"g'"). visLil(a,"a'"). visLil(b,"b'").
visLil(c1,"c''"). visLil(d1,"d''"). visLil(e1,"e''"). visLil(f1,"f''"). visLil(g1,"g''"). visLil(a1,"a''"). visLil(b1,"b''").
dolLil(p,"2"). dolLil(c,"4"). dolLil(cp,"4."). dolLil(b,"\\breve").
vlil(n(_,V,D),R):-visLil(V,VL),dolLil(D,DL),append(VL,DL,R).
lil(Z)-->"\\version \"2.22.0\" {\n\\override Staff.TimeSignature.color = #white\n",
         "\\override Staff.TimeSignature.layer = #-1\n\\cadenzaOn\n",
         liln(Z,0)," \\bar \"|.\"\n}\n",
         "\\addlyrics {\n", lill(Z), "\n}\n".
omej(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(0)))))))))))))))).
liln([z(_,V,D,T)|N],X)-->{omej(O),dif(O,X),vlil(n(T,V,D),R)}, " ", R, liln(N,s(X)).
liln([vz(B,n(T,V,D))|N],X)-->{omej(O),dif(O,X)}, liln([z(B,V,D,T)|N],X).
liln([pov(_,[P|T])|N],X)-->{omej(O),dif(O,X)}, lilnt([P]),"(",lilnt(T), ") ",liln(N,s(X)).
liln([],_)-->[].
liln(X,O)-->{omej(O)},"\\bar \"\" \\break ",liln(X,0).
lilnt([n(T,V,D)|N])-->{N=[_|_]},liln([z("",V,D,T)],0),lilnt(N).
lilnt([n(T,V,D)])-->liln([z("",V,D,T)],0).
lilnt([])-->[].
lill([])-->[].
lill([vz(B,_)|N])-->"\"",B,"\" ",lill(N).
lill([z(B,_,_,_)|N])-->lill([vz(B,_)|N]).
lill([pov(B,_)|N])-->lill([vz(B,_)|N]).
