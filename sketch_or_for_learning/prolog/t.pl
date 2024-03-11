:-use_module(library(clpz)).

od(X,Y,R):-X*Y//100#=R.
a(X,Y):-od(X,Y,R1),od(Y,X,R2),R1#=R2.
