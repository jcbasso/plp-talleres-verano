mapaEjemplo([
      bicisenda(arenales, retiro, 30),
      bicisenda(arenales, libertad, 20),
      bicisenda(retiro, libertad, 10),
      bicisenda(belgrano,retiro,5)]).

%% Ejercicio 1
%% estaciones(+M, -Es)

%% estaciones(M, Es):- estaciones2(M,L), sort(L,Es).
%% estaciones2([],[]).
%% estaciones2([bicisenda(E1,E2,_)|Bs],[E1,E2|Es]):- estaciones2(Bs,Es).

estaciones(M, Es):- setof(E, estacionConRepetidos(M, E), Es).

estacionConRepetidos([bicisenda(E1,_,_)|_], E1).
estacionConRepetidos([bicisenda(_,E2,_)|_], E2).
estacionConRepetidos([_|Bs], E):- estacionConRepetidos(Bs, E).

%% Ejercicio 2
%% estacionesVecinas(+M,  ?E,  ?Es)
estacionesVecinas(M, E, Es):- setof(Re, estacionVecina(M, E, Re), Es).

estacionVecina(M, E, Re):- dataDeEstaciones(M, E, Re, _).

dataDeEstaciones(M, E1, E2, D):- dataDeEstaciones2(M, E1, E2, D).
dataDeEstaciones(M, E1, E2, D):- dataDeEstaciones2(M, E2, E1, D).

dataDeEstaciones2([bicisenda(E1, E2, D)|_], E1, E2, D).
dataDeEstaciones2([_|Bs], E1, E2, D):- dataDeEstaciones2(Bs, E1, E2, D).

%% Ejercicio 3
%% distanciaVecinas(+M, ?E1, ?E2, ?N)

distanciaVecinas(M, E1, E2, D):- dataDeEstaciones(M, E1, E2, D).