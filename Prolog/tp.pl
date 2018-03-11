mapaEjemplo([
      bicisenda(arenales, retiro, 30),
      bicisenda(arenales, libertad, 20),
      bicisenda(retiro, libertad, 10),
      bicisenda(belgrano,retiro,5)]).

%% Ejercicio 1
%% estaciones(+B, -Es)

estaciones(B, Es):- setof(E, estacionConRepetidos(B, E), Es).

estacionConRepetidos([bicisenda(E1,_,_)|_], E1).
estacionConRepetidos([bicisenda(_,E2,_)|_], E2).
estacionConRepetidos([_|Bs], E):- estacionConRepetidos(Bs, E).

%% Otra implementacion:
%% estaciones(B, Es):- estaciones2(B,L), sort(L,Es).
%% estaciones2([],[]).
%% estaciones2([bicisenda(E1,E2,_)|Bs],[E1,E2|Es]):- estaciones2(Bs,Es).

%% Ejercicio 2
%% estacionesVecinas(+B,  ?E,  ?Es)
estacionesVecinas(B, E, Es):- setof(Re, estacionVecina(B, E, Re), Es).

estacionVecina(B, E, Re):- dataDeEstaciones(B, E, Re, _).

dataDeEstaciones(B, E1, E2, D):- member(bicisenda(E1,E2,D),B).
dataDeEstaciones(B, E1, E2, D):- member(bicisenda(E2,E1,D),B).

%% Ejercicio 3
%% distanciaVecinas(+B, ?E1, ?E2, ?N)

distanciaVecinas(B, E1, E2, D):- dataDeEstaciones(B, E1, E2, D).

%% Ejercicio 4
%% caminoSimple(+B, +O, +D, ?C)
caminoSimple(B, O, D, Es):- setof(Ess, caminoSimpleConRepetidos(B, O, D, Ess), Esss), member(Es,Esss).

caminoSimpleConRepetidos(B, E, E, [E]):- dataDeEstaciones(B, E, _, _).
caminoSimpleConRepetidos(B, O, D, [O| Es]):- dataDeEstaciones(B, O, E, _), borrarTodasLasBicisendasDe(B, O, B2), caminoSimpleConRepetidos(B2, E, D, Es).
caminoSimpleConRepetidos(B, O, D, [O, D]):- dataDeEstaciones(B, O, D, _).

borrarTodasLasBicisendasDe([], _, []).
borrarTodasLasBicisendasDe([bicisenda(E1,E2,D)|Bs], E, [bicisenda(E1,E2,D)|Bss]):- E1 \= E, E2 \= E, borrarTodasLasBicisendasDe(Bs, E, Bss).
borrarTodasLasBicisendasDe([bicisenda(E,_,_)|Bs], E, Bss):- borrarTodasLasBicisendasDe(Bs, E, Bss).
borrarTodasLasBicisendasDe([bicisenda(_,E,_)|Bs], E, Bss):- borrarTodasLasBicisendasDe(Bs, E, Bss).