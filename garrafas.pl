inicial(C1,C2,estado(C1,C2,0,0)).

objetivoI(L, estado(_,_,L,_)).
objetivoD(L, estado(_,_,_,L)).

movimiento(estado(X,Y,I0,D0), estado(X,Y,0,D0), 'vaciarI'):- I0\=0.
movimiento(estado(X,Y,I0,D0), estado(X,Y,I0,0), 'vaciarD'):- D0\=0.
movimiento(estado(X,Y,I0,D0), estado(X,Y,X,D0), 'llenarI'):- I0\=X.
movimiento(estado(X,Y,I0,D0), estado(X,Y,I0,Y), 'llenarD'):- D0\=Y.
movimiento(estado(X,Y,I0,D0), estado(X,Y,0,D1), 'trasvasarID'):- I0 \= 0, A is Y - D0, B is I0, A >= B, D1 is D0 + I0. /* A es lo que cabe en la de la derecha, B es lo que tienes en la izqda, A >= B */
movimiento(estado(X,Y,I0,D0), estado(X,Y,I1,Y), 'trasvasarID'):- I0 \= 0, A is Y - D0, B is I0, A < B, I1 is I0 - (Y - D0).  /* A es lo que cabe en la de la derecha, B es lo que tienes en la izqda,
                                                                                                                              I1 debe ser lo que tenías menos lo que echas, que es Y - D0 */
movimiento(estado(X,Y,I0,D0), estado(X,Y,I1,0), 'trasvasarDI'):- D0 \= 0, A is X - I0, B is D0, A >= B, I1 is I0 + D0. /* A es lo que cabe en la de la izquierda, B es lo que tienes en la dcha, A >= B */
movimiento(estado(X,Y,I0,D0), estado(X,Y,X,D1), 'trasvasarDI'):- D0 \= 0, A is X - I0, B is D0, A < B, D1 is D0 - (X - I0).  /* A es lo que cabe en la de la izqda, B es lo que tienes en la dcha,
                                                                                                                              D1 debe ser lo que tenías menos lo que echas, que es X - I0 */
                                                                                                                              /*
                                                                                                                                Poniendo el vaciar al final se reducen el numero de estados explorados y el coste del camino
                                                                                                                                (en el caso general salvo en un conjunto de medida nula) XDDDDDDDDDDDDDDDDDDDDDDDDD
                                                                                                                              */



puede(_,Litros,_,_,_):- L is Litros, L < 0, !, fail.
puede(Estado, Litros, _, [], [Estado]):- objetivoI(Litros, Estado),!.
puede(Estado, Litros, _, [], [Estado]):- objetivoD(Litros, Estado),!.
puede(Estado, Litros, Visitados, [Operador|Operadores], [Estado|Estados]):-
              movimiento(Estado, EstadoSig, Operador),
              \+ member(EstadoSig,Visitados),
              puede(EstadoSig, Litros, [EstadoSig|Visitados], Operadores, Estados),!.

consulta(C1,C2,L) :- inicial(C1,C2,Estado), puede(Estado, L, [Estado], Operadores, Estados), nl,
write('Solución sin repetición de estados: '), nl,
write(Operadores), nl, write('Estados camino: '), nl, write(Estados).

parte2:- consulta(3,4,2).


