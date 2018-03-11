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

estaciones(M, Es):- setof(E, estacion(M, E), Es).

estacionConRepetidos([bicisenda(E1,_,_)|_], E1).
estacionConRepetidos([bicisenda(_,E2,_)|_], E2).
estacionConRepetidos([_|Bs], E):- estacion(Bs, E).

%% Ejercicio 2
%% estacionesVecinas(+M,  ?E,  ?Es)
estacionesVecinas(M, E, Es):- setof(Re, estacionVecina(M, E, Re), Es).

estacionVecina(M, E, Re):- dataDeEstaciones(M, E, Re, _).
estacionVecina(M, E, Re):- dataDeEstaciones(M, Re, E, _).

dataDeEstaciones([bicisenda(E1, E2, L)|_], E1, E2, L).
dataDeEstaciones([_|Bs], E1, E2, L):- dataDeEstaciones(Bs, E1, E2, L).
