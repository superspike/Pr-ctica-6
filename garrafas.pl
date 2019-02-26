%inicial(+C1,+C2,-Estado).
inicial(C1,C2,estado(C1,C2,0,0)).

%objetivo(+L, +Estado).
%El estado es objetivo si tiene L litros en alguna de las dos garrafas.
objetivo(L, estado(_,_,L,_)).
objetivo(L, estado(_,_,_,L)).


%movimiento(+EstadoInicial,-EstadoFinal,-Operador).
movimiento(estado(X,Y,I0,D0), estado(X,Y,0,D0), 'vaciar izquierda'):- I0\=0.
movimiento(estado(X,Y,I0,D0), estado(X,Y,I0,0), 'vaciar derecha'):- D0\=0.
movimiento(estado(X,Y,I0,D0), estado(X,Y,X,D0), 'llenar izquierda'):- I0\=X.
movimiento(estado(X,Y,I0,D0), estado(X,Y,I0,Y), 'llenar derecha'):- D0\=Y.
movimiento(estado(X,Y,I0,D0), estado(X,Y,0,D1), 'trasvasar de izquierda a derecha'):- I0 \= 0, A is Y - D0, B is I0, A >= B, D1 is D0 + I0.
/* A es lo que cabe en la de la derecha, B es lo que tienes en la izqda, A >= B */
movimiento(estado(X,Y,I0,D0), estado(X,Y,I1,Y), 'trasvasar de izquierda a derecha'):- I0 \= 0, A is Y - D0, B is I0, A < B, I1 is I0 - (Y - D0).
/* A es lo que cabe en la de la derecha, B es lo que tienes en la izqda, I1 debe ser lo que tenías menos lo que echas, que es Y - D0 */
movimiento(estado(X,Y,I0,D0), estado(X,Y,I1,0), 'trasvasar de derecha a izquierda'):- D0 \= 0, A is X - I0, B is D0, A >= B, I1 is I0 + D0.
/* A es lo que cabe en la de la izquierda, B es lo que tienes en la dcha, A >= B */
movimiento(estado(X,Y,I0,D0), estado(X,Y,X,D1), 'trasvasar de derecha a izquierda'):- D0 \= 0, A is X - I0, B is D0, A < B, D1 is D0 - (X - I0).
/* A es lo que cabe en la de la izqda, B es lo que tienes en la dcha,   D1 debe ser lo que tenías menos lo que echas, que es X - I0 */
/*Poniendo el vaciar al final se reducen el numero de estados explorados y el coste del camino
           (generalmente y por el motor de inferencia de Prolog).*/



%puede(+Estado,+Litros,+Visitados,-Operadores,-Estados).
%No se puede si los litros son negativos y obviamente puede si llegas a un estado objetivo.
%En otro caso, tratas de ir a un estado no visitado ya.
puede(_,Litros,_,_,_):- Litros < 0, !, fail.
puede(Estado, Litros, _, [], [Estado]):- objetivo(Litros, Estado),!.
puede(Estado, Litros, Visitados, [Operador|Operadores], [Estado|Estados]):-
              movimiento(Estado, EstadoSig, Operador),
              \+ member(EstadoSig,Visitados),
              puede(EstadoSig, Litros, [EstadoSig|Visitados], Operadores, Estados),!.
              
%consulta(+C1,+C2,+L).
%dadas las capacidades de los recipientes y los litros a almacenar, calcula una solución al problema y la muestra por pantalla.
consulta(C1,C2,L) :- inicial(C1,C2,Estado), puede(Estado, L, [Estado], Operadores, Estados), nl,
write('Solución sin repetición de estados: '), nl, write(Operadores), nl, write('Estados camino: '), nl, write(Estados).

%consultaTest.
%Se corresponde al apartado II de la práctica, que es buscar un ejemplo de caso de prueba.
consultaTest:- consulta(3,4,2).


