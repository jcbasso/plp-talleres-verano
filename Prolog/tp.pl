mapaEjemplo([
      bicisenda(arenales, retiro, 30),
      bicisenda(arenales, libertad, 20),
      bicisenda(retiro, libertad, 10)]).

%% Ejercicio 1
%% estaciones(+M, -Es)

%% estaciones(M, Es):- estaciones2(M,L), sort(L,Es).
%% estaciones2([],[]).
%% estaciones2([bicisenda(E1,E2,_)|Bs],[E1,E2|Es]):- estaciones2(Bs,Es).

estacion([bicisenda(E1,_,_)|_],E1).
estacion([bicisenda(_,E2,_)|_],E2).
estacion([_|Bs],E):- estacion(Bs,E).

estaciones(M,Es):- setof(E,estacion(M,E),Es).