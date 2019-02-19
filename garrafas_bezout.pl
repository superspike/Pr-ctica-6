 /*
  //Algoritmo de Euclides extendidio
//ax + by = d = gcd(a,b) Devuelve d.
ll eea(ll a, ll b, ll& x, ll& y) {
ll xx = y = 0, yy = x = 1;
while (b) {
ll q = a / b, t = b; b = a%b; a = t;
t = xx; xx = x - q*xx; x = t;
t = yy; yy = y - q*yy; y = t;
}
return a;
}


def ecl (a,b):
if b>a:
return ecl (b,a)
if b ==0:
alfa_a_b =1
beta_a_b =0
mcd_a_b =a
else :
q,r = divmod (a,b)
alfa_b_r , beta_b_r , mcd_b_r = ecl (b,r)
alfa_a_b = beta_b_r
beta_a_b = alfa_b_r - beta_b_r * q
mcd_a_b = mcd_b_r
chequea_invariante (a,b, alfa_a_b , beta_a_b , mcd_a_b )
return ( alfa_a_b , beta_a_b , mcd_a_b )

*/

/*http://mate.dm.uba.ar/~pdenapo/apuntes-algebraI/clase_de_algebra_sobre_el_algoritmo_de_Euclides.pdf*/

%eea(+A,+B,-X,-Y,-D).
eea(A,B,X,Y,D):- nonvar(D), eea(A,B,X_,Y_,D__), D_ is D__,  F is mod(D,D_), F == 0, Q is div(D,D_), X is X_*Q, Y is Y_*Q,!.
eea(A,B,_,_,D):- nonvar(D), eea(A,B,_,_,D_), F is mod(D,D_), F  \= 0, !, fail.
eea(A,B,X,Y,D):- A_ is A, B_ is B, B_ > A_, eea(B,A,Y,X,D),!.
eea(A,0,1,0,A):- !.
eea(A,B,X,Y,D):- L is mod(A,B), Q is div(A,B), eea(B,L,X_,Y_,D), X is Y_, Y is X_ - Y_*Q.

inverso(estado(C1,C2,X,Y), estado(C2,C1,Y,X)).

inicial(C1,C2,estado(C1,C2,0,0)).

%movimiento(A,B,Estado,Operadores,Estados):- A_ is A, A_ < 0, inverso(Estado, Estado_), movimiento(B,A,Esdo_,Operadores,Estados),!.


movimiento(A,B,estado(C1,C2,0,Y),['llenar'|Operadores],[estado(C1,C2,0,Y)|Estados]):- A_ is A, A_>0, AAux is A-1, write('llenar'),nl, movimiento(AAux,B,estado(C1,C2,C1,Y), Operadores, Estados),!.
movimiento(A,B,estado(C1,C2,X,Y),['trasvasar'|Operadores],[estado(C1,C2,X,Y)|Estados]):- (A > 0; A == 0,B \= 0), C2-Y>=X, Z is Y+X , X\=0, write('trasvasar'),nl, movimiento(A,B,estado(C1,C2,0,Z), Operadores, Estados),!.
movimiento(A,B,estado(C1,C2,X,Y),['trasvasar'|Operadores],[estado(C1,C2,X,Y)|Estados]):- (A > 0; A == 0,B\=0), C2-Y < X, C2 \= Y, Z is X-(C2-Y) , write('trasvasar'),nl, movimiento(A,B,estado(C1,C2,Z,C2), Operadores, Estados),!.
movimiento(0,0,estado(C1,C2,X,Y),['trasvasar'|Operadores],[estado(C1,C2,X,Y)|Estados]):- C2-Y>=X, Z is Y+X , X\=0,  write('trasvasar'),nl,movimiento(0,0,estado(C1,C2,0,Z), Operadores, Estados),!.
movimiento(A,B,estado(C1,C2,X,C2),['vaciar'|Operadores],[estado(C1,C2,X,C2)|Estados]):-  B_ is B, B_<0, BAux is B+1, write('vaciar'),nl, movimiento(A,BAux,estado(C1,C2,X,0), Operadores, Estados),!.
/* SI X*A+Y*B=D, X > Y, se da que si Y|X => A=0, B=Y/X>0*/
/*movimiento(0,B,estado(C1,C2,X,0),['llenarD'|Operadores],[estado(C1,C2,X,C2)|Estados]):-  B_ is B, B_>0, BAux is B-1, movimiento(0,BAux,estado(C1,C2,X,C2), Operadores, Estados),!.
movimiento(0,B,estado(C1,C2,X,Y),['trasvasarDI'|Operadores],[estado(C1,C2,X,Y)|Estados]):- C2_ is C2, X_ is X, Y_ is Y, Y\=0, Z is Y+X , X\=0, movimiento(A,B,estado(C1,C2,0,Z), Operadores, Estados),!.*/
movimiento(0,0,Estado,[],[Estado]).

consultaBezout(C1,C2,L):- L > C1, L > C2, !, fail.
consultaBezout(C1,C2,L):- inicial(C1,C2,Estado), eea(C1,C2,X,Y,L), X > 0, movimiento(X,Y,Estado, Operadores, Estados), write(Operadores), nl, write(Estados), nl,!.
consultaBezout(C1,C2,L):- inicial(C1,C2,Estado), eea(C1,C2,X,Y,L), inverso(Estado,Estado_), write(Estado -> Estado_),nl, movimiento(Y,X,Estado_, Operadores, Estados), write(Operadores), nl, write(Estados), nl.



%?- inicial(3,4,Estado), movimiento(4,-2,Estado, Operadores, Estados), write(Operadores), nl, write(Estados), nl.