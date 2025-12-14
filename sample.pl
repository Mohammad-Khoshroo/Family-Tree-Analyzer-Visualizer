% --- discontiguous directives ---
:- discontiguous male/1.
:- discontiguous female/1.
:- discontiguous parent/2.
:- discontiguous married/2.

% --- Generation 1 ---
parent(diana, ethan).
parent(diana, fiona).
parent(edward, ethan).
parent(edward, fiona).

female(diana).
male(edward).
married(diana, edward).

% --- Generation 2 ---
parent(ethan, gabriel).
parent(ethan, hannah).
parent(claire, gabriel).
parent(claire, hannah).

parent(fiona, ian).
parent(fiona, julia2).
parent(henry, ian).
parent(henry, julia2).

male(ethan). female(fiona). female(claire). male(henry).
married(ethan, claire). married(fiona, henry).

% --- Generation 3 ---
parent(gabriel, karl).
parent(gabriel, laura).
parent(amelia, karl).
parent(amelia, laura).

parent(hannah, max).
parent(hannah, nina).
parent(oliver, max).
parent(oliver, nina).

parent(ian, oscar).
parent(ian, paula).
parent(sophia2, oscar).
parent(sophia2, paula).

parent(julia2, quinn).
parent(julia2, rachel).
parent(james2, quinn).
parent(james2, rachel).

male(gabriel). female(hannah). female(amelia). male(oliver).
male(ian). female(sophia2). female(julia2). male(james2).

married(gabriel, amelia). married(hannah, oliver).
married(ian, sophia2). married(julia2, james2).

% --- Generation 4 ---
male(karl). female(laura). male(max). female(nina).
male(oscar). female(paula). male(quinn). female(rachel).

% --- Generation 5 ---
parent(karl, samuel). parent(karl, tina). parent(emma3, samuel). parent(emma3, tina).
parent(laura, victor). parent(laura, wendy). parent(liam2, victor). parent(liam2, wendy).
parent(max, xavier). parent(max, yvonne). parent(maya, xavier). parent(maya, yvonne).
parent(oscar, zach). parent(oscar, alice2). parent(noah3, zach). parent(noah3, alice2).
parent(quinn, ben). parent(quinn, carla). parent(luke2, ben). parent(luke2, carla).

male(samuel). female(tina). male(victor). female(wendy). male(xavier). female(yvonne).
male(zach). female(alice2). male(ben). female(carla).
female(emma3). male(liam2). female(maya). male(noah3). male(luke2).

married(karl, emma3). married(laura, liam2). married(max, maya). married(oscar, noah3). married(quinn, luke2).

% --- Generation 6 ---
parent(samuel, daniel). parent(tina2, daniel).    % tina2 instead of tina
parent(victor, evelyn). parent(wendy2, evelyn).   % wendy2 instead of wendy
parent(xavier, felix). parent(yvonne2, felix).     % yvonne2 instead of yvonne
parent(zach, grace2). parent(alice3, grace2).      % alice3 instead of alice2
parent(ben, hannah2). parent(carla2, hannah2).     % carla2 instead of carla

male(daniel). female(tina2). female(evelyn). female(wendy2).
male(felix). female(yvonne2). female(grace2). female(alice3).
male(hannah2). female(carla2).

married(samuel, tina2). married(victor, wendy2). married(xavier, yvonne2). married(zach, alice3). married(ben, carla2).


% --- gender inference ---
gender(X, male) :- male(X), !.
gender(X, female) :- female(X), !.
gender(_, unknown).

% --- basic family rules ---
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.
father(X, Y) :- male(X), parent(X, Y).
mother(X, Y) :- female(X), parent(X, Y).
ancestor(X, Y) :- parent(X, Y); (parent(X, Z), ancestor(Z, Y)).
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).
uncle(X, Y) :- male(X), parent(Z, Y), sibling(X, Z).
aunt(X, Y) :- female(X), parent(Z, Y), sibling(X, Z).
cousin(X, Y) :- parent(A, X), parent(B, Y), sibling(A, B), X \= Y.
male_cousin(X, Y) :- cousin(X, Y), male(X).
female_cousin(X, Y) :- cousin(X, Y), female(X).

% --- validation rules ---
check_incest :-
    findall(X-Y-Child, (parent(X, Child), parent(Y, Child), X \= Y, sibling(X, Y)), Violations),
    (Violations = [] -> 
        write('✅ No incest detected.\n') 
    ; 
        write('⚠️  WARNING: Incest detected!\n'),
        forall(member(P1-P2-C, Violations),
               format('   ~w and ~w (siblings) have child ~w\n', [P1, P2, C]))
    ).

% --- determine generation (fixed with spouse consideration) ---
% First: if person has a parent, generation is parent's generation + 1
generation(X, N) :- 
    parent(P, X), 
    !, 
    generation(P, GP), 
    N is GP + 1.

% Second: if person has no parent but is married to someone with a generation, use spouse's generation
generation(X, N) :- 
    \+ parent(_, X),
    (married(X, Y); married(Y, X)),
    parent(_, Y),
    !,
    generation(Y, N).

% Third: if neither person nor spouse has parent, they are generation 1 (root)
generation(X, 1) :- 
    \+ parent(_, X),
    !.

% --- helper: get spouse ---
spouse(X, Y) :- married(X, Y), !.
spouse(X, Y) :- married(Y, X), !.

% --- helper: get max generation depth ---
max_depth(MaxGen) :-
    findall(Gen, generation(_, Gen), Gens),
    (Gens = [] -> MaxGen = 0 ; max_list(Gens, MaxGen)).

% --- export graph ---
export_family_graph(File) :-
    open(File, write, Stream),
    write(Stream, 'digraph FamilyTree {\n'),
    write(Stream, '    rankdir=TB;\n'),
    write(Stream, '    node [shape=box, style="rounded,filled", fontname="Arial", margin=0.2];\n'),
    write(Stream, '    edge [arrowsize=0.8];\n\n'),

    % --- collect all people ---
    findall(P, (parent(P,_); parent(_,P); married(P,_); married(_,P)), PeopleUnsorted),
    sort(PeopleUnsorted, People),
    
    % --- draw nodes with colors ---
    forall(member(P, People),
           (gender(P, G), 
            color_for_gender(G, Color), 
            format(Stream, '    "~w" [fillcolor="~w"];\n', [P, Color]))
    ),
    write(Stream, '\n'),

    % --- group by generation with subgraph ---
    findall(Gen, generation(_, Gen), AllGens),
    sort(AllGens, UniqueGens),
    
    forall(member(Gen, UniqueGens),
           (findall(Name, (member(Name, People), generation(Name, Gen)), PeopleInGen),
            PeopleInGen \= [],
            format(Stream, '    { rank=same; ', []),
            forall(member(PName, PeopleInGen), 
                   format(Stream, '"~w"; ', [PName])),
            write(Stream, '}\n'))
    ),
    write(Stream, '\n'),

    % --- parent edges ---
    forall(parent(X, Y), 
           format(Stream, '    "~w" -> "~w" [color="#555555", penwidth=1.5];\n', [X, Y])),
    write(Stream, '\n'),

    % --- marriage edges (undirected, both directions) ---
    findall(X-Y, (married(X, Y); married(Y, X)), MarriagesAll),
    sort(MarriagesAll, MarriagesUnique),
    findall(A-B, (member(A-B, MarriagesUnique), A @< B), Marriages),
    forall(member(X-Y, Marriages),
           format(Stream, '    "~w" -> "~w" [style=dashed, color="#d17b88", dir=none, penwidth=2.0, constraint=false];\n', [X, Y])),

    write(Stream, '}\n'),
    close(Stream).

% --- color by gender ---
color_for_gender(male, "#8ecae6").
color_for_gender(female, "#ffb6c1").
color_for_gender(unknown, "#dddddd").

% --- helper to run and generate file ---
run :- 
    export_family_graph('family_tree.dot'),
    write('Family tree exported to family_tree.dot\n'),
    write('Run: dot -Tpng family_tree.dot -o family_tree.png\n').