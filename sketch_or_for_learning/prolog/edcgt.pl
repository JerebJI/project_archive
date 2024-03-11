:-use_module('./nomads/nomads.pl').

:-thread(errs, [add], []).
:-thread_method(add(X), Old, New, New = [X|Old]).


n(z):--"mačka".
n(m):--"maček".
a(m):--"debel".
a(z):--"debela".
v :-- "je".
np :-- (a(X)," ";""), n(X).
svo :-- np, " ", v, " ", np.
