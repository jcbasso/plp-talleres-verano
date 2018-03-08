estaciones(M,ES):- setof(X, estacion(X,M), ES).
estacion(X,M):- member(bicisenda(X,_,_), M) ; member(bicisenda(_,X,_),M).
