%progenitor(?X,?Y).
progenitor(X, Y):-progenitores(X, _, Y).
progenitor(X, Y):-progenitores(_, X, Y).

%padre(?X,?Y).
%X es el padre de Y si es su progenitor y es hombre
padre(X, Y):-progenitor(X, Y), persona(X, hombre).

%madre(?X,?Y).
%X es la madre de Y si es su progenitor y es mujer
madre(X, Y):-progenitor(X, Y),persona(X, mujer).

%hijo(?X,?Y).
%X es el hijo de Y si Y es su progenitor y es hombre
hijo(X, Y):-progenitor(Y, X),persona(X, hombre).

%hija(?X,?Y).
%X es la hija de Y si Y es su progenitor y es mujer
hija(X, Y):-progenitor(Y, X),persona(X, mujer).

%hermano(?X,?Y).
%X es el hermano de Y si tienen un progenitor en común, son distintos y es hombre
hermano(X, Y):-progenitor(Z, X), progenitor(Z, Y), X\=Y, persona(X, hombre).

%hermana(?X,?Y).
%X es la hermana de Y si tienen un progenitor en común, son distintos y es mujer
hermana(X, Y):-progenitor(Z, X), progenitor(Z, Y), X\=Y, persona(X, mujer).

%abuelo(?X,?Y).
%X es el abuelo de Y si es padre de alguien que tiene como hijo/a a Y.
abuelo(X, Y):-padre(X, Z),progenitor(Z, Y).

%abuela(?X,?Y).
%X es la abuela de Y si es madre de alguien que tiene como hijo/a a Y.
abuela(X, Y):-madre(X, Z),progenitor(Z, Y).

%primo(?X,?Y).
%X es primo de Y si tienen un progenitor cada uno los cuales a su vez son hermanos y es hombre.
primo(X, Y):-progenitor(A, X), progenitor(B, Y), hermano(A, B), persona(X, hombre).
primo(X, Y):-progenitor(A, X), progenitor(B, Y), hermana(A, B), persona(X, hombre).

%prima(?X,?Y).
%X es prima de Y si tienen un progenitor cada uno los cuales a su vez son hermanos y es mujer.
prima(X, Y):-progenitor(A, X), progenitor(B, Y), hermano(A, B), persona(X, mujer).
prima(X, Y):-progenitor(A, X), progenitor(B, Y), hermana(A, B), persona(X, mujer).

primo(X, Y):-abuelo(Z, X), abuelo(Z, Y), X\=Y, persona(X, hombre).
primo(X, Y):-abuela(Z, X), abuela(Z, Y), X\=Y, persona(X, hombre).

prima(X, Y):-abuelo(Z, X), abuelo(Z, Y), X\=Y, persona(X, mujer).
prima(X, Y):-abuela(Z, X), abuela(Z, Y), X\=Y, persona(X, mujer).

%ascendiente(?X,?Y).
%X es ascendiente de Y si es un progenitor o si es progenitor de algún ascendiente de Y.
ascendiente(X, Y):-progenitor(X, Y),!. %Lleva un corte para evitar respuestas redundantes cuando el arbo familiar es enrevesado.
ascendiente(X, Y):-progenitor(X, Z), ascendiente(Z, Y).

%hechos.
persona(juan, hombre).
persona(maria, mujer).
persona(rosa, mujer).
persona(luis, hombre).
persona(jose, hombre).
persona(laura, mujer).
persona(pilar, mujer).
persona(miguel, hombre).
persona(isabel, mujer).
persona(jaime, hombre).
persona(pedro, hombre).
persona(pablo, hombre).
persona(begoña, mujer).

progenitores(juan, maria, rosa).
progenitores(maria, juan, luis).
progenitores(jose, laura, pilar).
progenitores(pilar, luis, miguel).
progenitores(miguel, isabel, jaime).
progenitores(pedro, rosa, pablo).
progenitores(pedro, rosa, begoña).