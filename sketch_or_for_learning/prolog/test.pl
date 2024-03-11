:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(charsio)).
:- use_module(library(lists)).

ws --> [].
ws --> [X], ws, {char_type(X,whitespace)}.

ident([]) --> [].
ident([E|Es]) --> [E], ident(Es), {char_type(E,alphanumeric)}.

expr(S) --> ws, ident(I), ws, {atom_chars(S,I)}.
expr(E) --> ws, ident(A), {atom_chars(S,A)}, "[", exprv(B), ws, "]", ws, {append([S],B,R),E=..R}.

exprv([]) --> [] | ws.
exprv([E]) --> ws, expr(E).
exprv([E|Es]) --> ws, expr(E), ws, ",", exprv(Es).

exprs([]) --> [].
exprs([E|Es]) --> expr(E), exprs(Es).
