:- use_module(library(http/http_open)).
:- use_module(library(sgml)).
:- use_module(library(xpath)).
:- use_module(library(dcgs)).

t(V,R):-http_open("https://hozana.si",S,[]), load_html(stream(S),DOM,[]), bagof(X,xpath(DOM,V,X),R).
ps(R):-http_open("https://hozana.si",S,[]), load_html(stream(S),DOM,[]),
       bagof(X,(xpath(DOM,//h2(text),X),phrase((...,"salm",...),X)),R).
