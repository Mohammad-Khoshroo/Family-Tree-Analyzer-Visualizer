% ==============================================================================
% FAMILY TREE RULES
% ==============================================================================
% This file contains all the logical rules for family relationships

:- discontiguous male/1.
:- discontiguous female/1.
:- discontiguous parent/2.
:- discontiguous married/2.
:- discontiguous has_parent/1.
:- discontiguous generation/2.

% --- Gender Inference ---
gender(X, male) :- male(X), !.
gender(X, female) :- female(X), !.
gender(_, unknown).

% --- Basic Relationships ---
sibling(X, Y) :- 
    parent(Z, X), 
    parent(Z, Y), 
    X \= Y.

father(X, Y) :- 
    male(X), 
    parent(X, Y).

mother(X, Y) :- 
    female(X), 
    parent(X, Y).

ancestor(X, Y) :- 
    parent(X, Y).
ancestor(X, Y) :- 
    parent(X, Z), 
    ancestor(Z, Y).

grandparent(X, Y) :- 
    parent(X, Z), 
    parent(Z, Y).

grandfather(X, Y) :- 
    male(X), 
    grandparent(X, Y).

grandmother(X, Y) :- 
    female(X), 
    grandparent(X, Y).

% --- Extended Family ---
uncle(X, Y) :- 
    male(X), 
    parent(Z, Y), 
    sibling(X, Z).

aunt(X, Y) :- 
    female(X), 
    parent(Z, Y), 
    sibling(X, Z).

cousin(X, Y) :- 
    parent(A, X), 
    parent(B, Y), 
    sibling(A, B), 
    X \= Y.

male_cousin(X, Y) :- 
    cousin(X, Y), 
    male(X).

female_cousin(X, Y) :- 
    cousin(X, Y), 
    female(X).

% --- Spouse Relationship (Bidirectional) ---
% This makes married relationship work both ways
spouse(X, Y) :- married(X, Y).
spouse(X, Y) :- married(Y, X).

% --- Generation Calculation (Stable Final Version) ---
% Helper: Check if person has a parent
has_parent(X) :- parent(_, X).

% Root generation: no parent and no spouse
generation(X, 1) :-
    \+ has_parent(X),
    \+ married(X, _),
    \+ married(_, X), !.

% Recursive: child generation
generation(X, N) :-
    parent(P, X),
    generation(P, GP),
    N is GP + 1, !.

% Married but no parent → same generation as spouse,
% only if the spouse's generation is already defined (spouse has a parent or spouse is linked)
generation(X, N) :-
    \+ has_parent(X),
    (married(X, Y) ; married(Y, X)),
    X \= Y,
    has_parent(Y),          % 🔹 only follow if spouse has a parent
    generation(Y, N), !.

% Fallback for two root spouses without parents
generation(X, 1) :-
    \+ has_parent(X),
    (married(X, Y) ; married(Y, X)),
    \+ has_parent(Y), !.

% --- Helper: Get max generation ---
max_generation(MaxGen) :-
    findall(Gen, generation(_, Gen), Gens),
    (Gens = [] -> MaxGen = 0 ; max_list(Gens, MaxGen)).