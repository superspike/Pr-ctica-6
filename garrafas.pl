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
eea(A,B,1,0,A):- B==0,!.
eea(A,B,X,Y,D):- L is mod(A,B), Q is div(A,B), eea(B,L,X_,Y_,D), X is Y_, Y is X_ - Y_*Q.