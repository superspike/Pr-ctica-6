%eea(+A,+B,-X,-Y,-D).
eea(A,B,X,Y,D):- nonvar(D), eea(A,B,X_,Y_,D__), D_ is D__,  F is mod(D,D_), F == 0, Q is div(D,D_), X is X_*Q, Y is Y_*Q,!.
eea(A,B,_,_,D):- nonvar(D), eea(A,B,_,_,D_), F is mod(D,D_), F  \= 0, !, fail.
eea(A,B,X,Y,D):- B > A, eea(B,A,Y,X,D),!.
eea(A,0,1,0,A):- !.
eea(A,B,X,Y,D):- L is mod(A,B), Q is div(A,B), eea(B,L,X_,Y_,D), X is Y_, Y is X_ - Y_*Q.

%optieeaX(+A,+B,+X,+Y,-Ap,-Bp,-Xp,-Yp)
%A*X+B*Y = D, A>0, B>0, D>0, X >= 0, Y <= 0.
optieeaX(A,B,X,Y,A,B,Xp,Yp):- X > 0, K is div(X,B), Xp is X - K*B, Yp is Y+K*A, Xp > 0,  Xp - Yp < X - Y, Xp - Yp < -(Xp-B)+(Yp+A),!. %Xp siempre es >= 0.
optieeaX(A,B,X,Y,B,A,Yp,Xp):- X > 0, K is div(X,B), Xp is X - (K+1)*B, Yp is Y+(K+1)*A, -Xp + Yp < X - Y, -Xp + Yp < Xp+B-(Yp-A),!. %Xp es < 0 => Yp > 0.
optieeaX(A,B,X,Y,B,A,Yp,Xp):- X > 0, K is div(X,B), Xp is X - K*B, Yp is Y+K*A, Xp == 0,  Xp + Yp < X - Y,!. %Xp == 0 => Yp > 0.
optieeaX(A,B,X,Y,A_,B_,Xp,Yp):- X == 0, Y > 0, optieeaX(B,A,Y,X,A_,B_,Xp,Yp),!.
optieeaX(A,B,X,Y,A,B,X,Y).

%optieeaY(+A,+B,+X,+Y,-Ap,-Bp,-Xp,-Yp)
%A*X+B*Y = D, A>0, B>0, D>0, X >= 0, Y <= 0.
optieeaY(A,B,X,Y,A,B,Xp,Yp):- Y < 0, K is div(-Y,A), Xp is X - K*B, Yp is Y+K*A, Yp < 0,  Xp - Yp < X - Y, Xp - Yp < -(Xp-B)+(Yp+A), !. %Yp siempre es <= 0.
optieeaY(A,B,X,Y,B,A,Yp,Xp):- Y < 0, K is div(-Y,A), Xp is X - (K+1)*B, Yp is Y+(K+1)*A, -Xp + Yp < X - Y,-Xp + Yp < Xp+B-(Yp-A),!.  %Yp > 0 => Xp < 0, Yp - A < 0.
optieeaY(A,B,X,Y,A,B,Xp,Yp):- Y < 0, K is div(-Y,A), Xp is X - K*B, Yp is Y+K*A, Yp == 0,  Xp - Yp < X - Y,!. %Yp == 0 => Xp > 0
optieeaY(A,B,X,Y,A_,B_,Xp,Yp):- Y == 0, X < 0, optieeaY(B,A,Y,X,A_,B_,Xp,Yp),!.
optieeaY(A,B,X,Y,A,B,X,Y).

%optieea(+A,+B,+X,+Y,-Ap,-Bp,-Xp,-Yp)
optieea(A,B,X,Y,A_,B_,X_,Y_):- X < Y, optieea(B,A,Y,X,A_,B_,X_,Y_),!.   %(X < 0; X==0, Y > 0) es equiv a X < Y
optieea(A,B,X,Y,A_,B_,X_,Y_):- optieeaX(A,B,X,Y,C,D,E,F), optieeaY(A,B,X,Y,C_,D_,E_,F_),(E-F < E_-F_, optieea(C,D,E,F,A_,B_,X_,Y_); (E_-F_ < E-F; E_-F_ < X-Y), optieea(C_,D_,E_,F_,A_,B_,X_,Y_)),!.
optieea(A,B,X,Y,A,B,X,Y).

%inicial(+C1,+C2,-Estado).
inicial(C1,C2,estado(C1,C2,0,0)).

%inicial(+C1,+C2,-Estado, -Coefs).
init(C1,C2,L, Estado, coefs(X_,Y_)):- eea(C1,C2,X,Y,L), optieea(C1,C2,X,Y,A,B,X_,Y_), inicial(A,B,Estado).

%movimiento(+A,+B,-Estado,-[Operadores],-[Estados]).
movimiento(A,B,estado(C1,C2,0,Y),['llenar'|Operadores],[estado(C1,C2,0,Y)|Estados],N):- A > 0, AAux is A - 1,movimiento(AAux,B,estado(C1,C2,C1,Y), Operadores, Estados,M),N is M+1,!.
movimiento(A,B,estado(C1,C2,X,Y),['trasvasar'|Operadores],[estado(C1,C2,X,Y)|Estados],N):- (A > 0; A == 0,B \= 0), C2 - Y >= X, Z is Y+X , X\=0, movimiento(A,B,estado(C1,C2,0,Z), Operadores, Estados,M),N is M+1,!.
movimiento(A,B,estado(C1,C2,X,Y),['trasvasar'|Operadores],[estado(C1,C2,X,Y)|Estados],N):- (A > 0; A == 0,B\=0), C2-Y < X, C2 \= Y, Z is X-(C2-Y) , movimiento(A,B,estado(C1,C2,Z,C2), Operadores, Estados,M),N is M+1,!.
movimiento(A,B,estado(C1,C2,X,C2),['vaciar'|Operadores],[estado(C1,C2,X,C2)|Estados],N):-  B < 0, BAux is B+1, movimiento(A,BAux,estado(C1,C2,X,0), Operadores, Estados,M),N is M+1,!.
  %Si X*A+Y*B=D, X > Y, se da que si Y|X => A=0, B=Y/X > 0 (luego dará problemas).
  %Caso final: hay que hacer un trasvase final por algún motivo.
movimiento(0,0,estado(C1,C2,X,Y),['trasvasar'],[estado(C1,C2,X,Y),estado(C1,C2,0,Z)],1):- C2 - Y >= X, Z is Y + X , X\=0, Y\=0,!.
  %Caso final: no hay que hacer ningún trasvase, todo va bien.
movimiento(0,0,Estado,[],[Estado],0).

%consultaBezout(+C1,+C2,+L).
consultaBezout(C1,C2,L):- L > C1, L > C2, !, fail.
consultaBezout(C1,C2,L):- init(C1,C2,L,Estado, coefs(X,Y)), movimiento(X,Y,Estado, Operadores, Estados,N),
  write('Solución sin repetición de estados: '), nl,nl, write('Operadores empleados: '),nl, write(Operadores),
  nl,nl, write('Estados recorridos: '), nl, write(Estados),nl,nl, write('Profundidad de la solución encontrada: '),
  write(N),write(' operadores'),nl.

%consultaBezoutTest.
%Ejemplo de caso de prueba para los datos del apartado II.
consultaBezoutTest:- consultaBezout(3,4,2).



%?- inicial(3,4,Estado), movimiento(4,-2,Estado, Operadores, Estados), write(Operadores), nl, write(Estados), nl.