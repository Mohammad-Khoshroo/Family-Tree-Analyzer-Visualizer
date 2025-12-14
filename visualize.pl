% ==============================================================================
% VISUALIZATION - GRAPHVIZ DOT EXPORT
% ==============================================================================
% This file handles exporting the family tree to Graphviz format

:- ['rules.pl'].

% --- Color Scheme ---
color_for_gender(male, "#8ecae6").
color_for_gender(female, "#ffb6c1").
color_for_gender(unknown, "#dddddd").

% --- Main Export Function ---
export_family_graph(File) :-
    format('~nGenerating family tree visualization...~n'),
    open(File, write, Stream),
    write_graph_header(Stream),
    write_nodes(Stream),
    write_generation_ranks(Stream),
    write_parent_edges(Stream),
    write_marriage_edges(Stream),
    write_graph_footer(Stream),
    close(Stream),
    format('✅ Graph exported to: ~w~n', [File]),
    format('   To generate image, run:~n'),
    format('   dot -Tpng ~w -o family_tree.png~n~n', [File]).

% --- Write Graph Header ---
write_graph_header(Stream) :-
    write(Stream, 'digraph FamilyTree {\n'),
    write(Stream, '    rankdir=TB;\n'),
    write(Stream, '    node [shape=box, style="rounded,filled", fontname="Arial", margin=0.2];\n'),
    write(Stream, '    edge [arrowsize=0.8];\n\n').

% --- Write All Nodes ---
write_nodes(Stream) :-
    write(Stream, '    // --- Nodes ---\n'),
    findall(P, (parent(P,_); parent(_,P); married(P,_); married(_,P)), PeopleUnsorted),
    sort(PeopleUnsorted, People),
    forall(member(P, People),
           (gender(P, G), 
            color_for_gender(G, Color), 
            format(Stream, '    "~w" [fillcolor="~w"];\n', [P, Color]))
    ),
    write(Stream, '\n').

% --- Write Generation Ranks (fixed) ---
write_generation_ranks(Stream) :-
    write(Stream, '    // --- Generational Ranks ---\n'),
    findall(P, (parent(P,_); parent(_,P); married(P,_); married(_,P)), PeopleUnsorted),
    sort(PeopleUnsorted, People),

    % --- compute generations only for concrete people (avoid generation(_,Gen) with unbound var)
    findall(Gen, (member(Pe, People), generation(Pe, Gen)), AllGensUnsorted),
    sort(AllGensUnsorted, UniqueGens),

    forall(member(Gen, UniqueGens),
           (
             findall(Name, (member(Name, People), generation(Name, Gen)), PeopleInGen),
             PeopleInGen \= [],
             format(Stream, '    { rank=same; ', []),
             forall(member(PName, PeopleInGen),
                    format(Stream, '"~w"; ', [PName])),
             write(Stream, '}\n')
           )
    ),
    write(Stream, '\n').

% --- Write Parent-Child Edges ---
write_parent_edges(Stream) :-
    write(Stream, '    // --- Parent-Child Relationships ---\n'),
    forall(parent(X, Y), 
           format(Stream, '    "~w" -> "~w" [color="#555555", penwidth=1.5];\n', [X, Y])),
    write(Stream, '\n').

% --- Write Marriage Edges ---
write_marriage_edges(Stream) :-
    write(Stream, '    // --- Marriages ---\n'),
    findall(X-Y, (spouse(X, Y), X @< Y), Marriages),
    sort(Marriages, UniqueMarriages),
    forall(member(X-Y, UniqueMarriages),
           format(Stream, '    "~w" -> "~w" [style=dashed, color="#d17b88", dir=none, penwidth=2.0, constraint=false];\n', [X, Y])),
    write(Stream, '\n').

% --- Write Graph Footer ---
write_graph_footer(Stream) :-
    write(Stream, '}\n').

% --- Generate Statistics ---
print_statistics :-
    format('~n'),
    format('═══════════════════════════════════════════════════════~n'),
    format('  FAMILY TREE STATISTICS~n'),
    format('═══════════════════════════════════════════════════════~n~n'),
    
    findall(P, (parent(P,_); parent(_,P)), AllPeople),
    sort(AllPeople, UniquePeople),
    length(UniquePeople, TotalPeople),
    format('  Total people: ~w~n', [TotalPeople]),
    
    findall(M, male(M), Males),
    length(Males, MaleCount),
    format('  Males: ~w~n', [MaleCount]),
    
    findall(F, female(F), Females),
    length(Females, FemaleCount),
    format('  Females: ~w~n', [FemaleCount]),
    
    findall(_, married(_, _), Marriages),
    length(Marriages, MarriageCount),
    format('  Marriages: ~w~n', [MarriageCount]),
    
    max_generation(MaxGen),
    format('  Generations: ~w~n', [MaxGen]),
    
    format('~n═══════════════════════════════════════════════════════~n~n').