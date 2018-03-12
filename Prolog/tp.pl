mapaEjemplo([
		bicisenda(arenales, retiro, 30),
		bicisenda(arenales, libertad, 20),
		bicisenda(retiro, libertad, 10)]).

%% Ejercicio 1
%% estaciones(+Bs, -Es)
estaciones(Bs, Es):- setof(E, estacionConRepetidos(Bs, E), Es).

estacionConRepetidos([bicisenda(E1,_,_)|_], E1).
estacionConRepetidos([bicisenda(_,E2,_)|_], E2).
estacionConRepetidos([_|Bs], E):- estacionConRepetidos(Bs, E).

estacion(Bs, E):- estaciones(Bs,Es), member(E, Es).

%% Otra implementacion:
%% estaciones(Bs, Es):- estaciones2(Bs,L), sort(L,Es).
%% estaciones2([],[]).
%% estaciones2([bicisenda(E1,E2,_)|Bs],[E1,E2|Es]):- estaciones2(Bs,Es).

%% Ejercicio 2
%% estacionesVecinas(+Bs,  ?E,  ?Es)
estacionesVecinas(Bs, E, Es):- setof(Re, estacionVecina(Bs, E, Re), Es).

estacionVecina(Bs, E, Re):- dataDeEstaciones(Bs, E, Re, _).

dataDeEstaciones(Bs, E1, E2, N):- member(bicisenda(E1,E2,N),Bs).
dataDeEstaciones(Bs, E1, E2, N):- member(bicisenda(E2,E1,N),Bs).

%% Ejercicio 3
%% distanciaVecinas(+Bs, ?E1, ?E2, ?N)
distanciaVecinas(Bs, E1, E2, N):- dataDeEstaciones(Bs, E1, E2, N).

%% Ejercicio 4
%% caminoSimple(+Bs, +O, +D, ?C)
caminoSimple(Bs, O, D, C):- setof(C2, caminoSimpleConRepetidos(Bs, O, D, C2), C3), member(C,C3).

caminoSimpleConRepetidos(Bs, E, E, [E]):- dataDeEstaciones(Bs, E, _, _).
caminoSimpleConRepetidos(Bs, O, D, [O| Es]):- 
		dataDeEstaciones(Bs, O, E, _), 
		E \= D,
		borrarTodasLasBicisendasDe(Bs, O, Bs2), 
		caminoSimpleConRepetidos(Bs2, E, D, Es).
caminoSimpleConRepetidos(Bs, O, D, [O, D]):- dataDeEstaciones(Bs, O, D, _).

borrarTodasLasBicisendasDe([], _, []).
borrarTodasLasBicisendasDe([bicisenda(E1,E2,D)|Bs], E, [bicisenda(E1,E2,D)|Bss]):- E1 \= E, E2 \= E, borrarTodasLasBicisendasDe(Bs, E, Bss).
borrarTodasLasBicisendasDe([bicisenda(E,_,_)|Bs], E, Bss):- borrarTodasLasBicisendasDe(Bs, E, Bss).
borrarTodasLasBicisendasDe([bicisenda(_,E,_)|Bs], E, Bss):- borrarTodasLasBicisendasDe(Bs, E, Bss).

%% Ejercicio 5
%% mapaValido(+Bs)
mapaValido(Bs):- mapaNoCiclico(Bs), forall(estacion(Bs, E), esValido(Bs, E)).

esValido(Bs, E1):- 
	forall(
		(
			estacion(Bs, E2),
			E1 \= E2
		),(
			noFormanCiclosTriviales(B1,B2),
			caminoSimple(Bs,E1,E2,_)
		)
	).

mapaNoCiclico(Bs):- forall(member(B,Bs),noCiclico(B)).

noCiclico(bicisenda(X,Y,_)):- X\=Y.

noFormanCiclosTriviales(bicisenda(X,Y,_), bicisenda(A,B,_)):-Y\=A.
noFormanCiclosTriviales(bicisenda(X,Y,_), bicisenda(A,B,_)):-X\=B.

%% Ejercicio 6
%% caminoHamiltoniano(+Bs, +O, +D, ?C)
caminoHamiltoniano(Bs, O, D, C):- caminoSimple(Bs, O, D, C), forall(estacion(Bs,E), member(E,C)).

%% Ejercicio 7
%% caminosHamiltonianos(+Bs, ?C)
caminosHamiltonianos(Bs, C):- setof(C2, todosLosCaminosHamiltonianos(Bs,C2), Cs), member(C,Cs).

todosLosCaminosHamiltonianos(Bs, C):- caminoSimple(Bs, O, D, _), caminoHamiltoniano(Bs, O, D, C).

%% Ejercicio 8
%% caminoMinimo(+Bs, +O, +D, ?C, ?N)
caminoMinimo(Bs, O, D, C, N):- 
		caminoSimpleConDistancia(Bs, O, D, C, N),
		forall(
			(
				caminoSimpleConDistancia(Bs, O, D, C2, N2),
				C2 \= C
			),
				N =< N2
		).

caminoSimpleConDistancia(Bs, O, D, C, N):- setof(C2, caminoSimpleConDistanciaConRepetidos(Bs, O, D, C2, N), C3), member(C,C3).

caminoSimpleConDistanciaConRepetidos(Bs, E, E, [E], N):- dataDeEstaciones(Bs, E, _, N).
caminoSimpleConDistanciaConRepetidos(Bs, O, D, [O| Es], N):- 
		dataDeEstaciones(Bs, O, E, N2),
		E \= D,
		borrarTodasLasBicisendasDe(Bs, O, Bs2), 
		caminoSimpleConDistanciaConRepetidos(Bs2, E, D, Es, N3), 
		N is N2 + N3.
caminoSimpleConDistanciaConRepetidos(Bs, O, D, [O, D], N):- dataDeEstaciones(Bs, O, D, N).