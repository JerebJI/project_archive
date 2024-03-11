en(s,v*t).
%en(X,Y*Z):-en(Y,X/Z).
en(X,Y/Z):-en(Y,Z*X).
en(X,Y/Z):-en(Y,X*Z).
