% ==============================================================================
% VALIDATION RULES
% ==============================================================================
% This file contains validation logic to detect data issues

:- use_module(library(lists)).
:- ['rules.pl'].

% --- Check for Incest (Siblings having children together) ---
check_incest_children :-
    findall(X-Y-Child, (
        parent(X, Child), 
        parent(Y, Child), 
        X \= Y, 
        sibling(X, Y)
    ), Violations),
    (Violations = [] -> 
        format('Incest (children) check: PASSED~n') 
    ; 
        format('WARNING: Siblings having children together!~n'),
        forall(member(P1-P2-C, Violations),
               format('   ~w and ~w (siblings) have child ~w~n', [P1, P2, C])),
        length(Violations, Count),
        format('   Total violations: ~w~n~n', [Count])
    ).

% --- Check for Incest (Siblings married to each other) ---
check_incest_marriage :-
    findall(X-Y, (
        spouse(X, Y),
        X @< Y,  % Avoid duplicates
        sibling(X, Y)
    ), Violations),
    (Violations = [] -> 
        format('Incest (marriage) check: PASSED~n') 
    ; 
        format('WARNING: Siblings married to each other!~n'),
        forall(member(P1-P2, Violations),
               format('   ~w and ~w are siblings AND married!~n', [P1, P2])),
        length(Violations, Count),
        format('   Total violations: ~w~n~n', [Count])
    ).

% --- Check for Same-Sex Marriages ---
check_same_sex_marriage :-
    findall(X-Y-G, (
        spouse(X, Y),
        X @< Y,  % Avoid duplicates
        gender(X, G),
        gender(Y, G),
        G \= unknown
    ), Violations),
    (Violations = [] -> 
        format('Same-sex marriage check: PASSED~n') 
    ; 
        format('WARNING: Same-sex marriages detected!~n'),
        forall(member(P1-P2-G, Violations),
               format('   ~w and ~w (both ~w) are married~n', [P1, P2, G])),
        length(Violations, Count),
        format('   Total violations: ~w~n~n', [Count])
    ).

% --- Check for Orphans (Children without both parents) ---
check_orphans :-
    findall(Child, (
        parent(_, Child),
        \+ (parent(P1, Child), parent(P2, Child), P1 \= P2)
    ), Orphans),
    sort(Orphans, UniqueOrphans),
    (UniqueOrphans = [] ->
        format('Orphan check: PASSED~n')
    ;
        format('WARNING: Children with only one parent:~n'),
        forall(member(C, UniqueOrphans),
               (findall(P, parent(P, C), Parents),
                format('   ~w has parent(s): ~w~n', [C, Parents]))),
        length(UniqueOrphans, Count),
        format('   Total: ~w~n~n', [Count])
    ).

% --- Check for Gender Consistency ---
check_gender_consistency :-
    findall(Person, (
        parent(Person, _),
        \+ male(Person),
        \+ female(Person)
    ), NoGender),
    sort(NoGender, UniqueNoGender),
    (UniqueNoGender = [] ->
        format('Gender check: PASSED~n')
    ;
        format('WARNING: People without gender:~n'),
        forall(member(P, UniqueNoGender),
               format('   ~w~n', [P])),
        length(UniqueNoGender, Count),
        format('   Total: ~w~n~n', [Count])
    ).

% --- Check for Marriage Consistency ---
check_marriage_consistency :-
    findall(X-Y, (
        parent(X, Child),
        parent(Y, Child),
        X \= Y,
        \+ married(X, Y),
        \+ married(Y, X)
    ), UnmarriedParents),
    sort(UnmarriedParents, UniqueUnmarried),
    (UniqueUnmarried = [] ->
        format('Marriage check: PASSED~n')
    ;
        format('WARNING: Parents not marked as married:~n'),
        forall(member(P1-P2, UniqueUnmarried),
               format('   ~w and ~w~n', [P1, P2])),
        length(UniqueUnmarried, Count),
        format('   Total: ~w~n~n', [Count])
    ).

% --- Check for Duplicate Parent Entries ---
check_duplicate_parents :-
    findall(P-C, parent(P, C), AllParents),
    sort(AllParents, UniqueParents),
    length(AllParents, Total),
    length(UniqueParents, Unique),
    Duplicates is Total - Unique,
    (Duplicates = 0 ->
        format('Duplicate check: PASSED~n')
    ;
        format('WARNING: ~w duplicate parent entries found~n~n', [Duplicates])
    ).

% --- Run All Validations ---
validate_all :-
    format('~n'),
    format('═══════════════════════════════════════════════════════~n'),
    format('  FAMILY TREE VALIDATION REPORT~n'),
    format('═══════════════════════════════════════════════════════~n~n'),
    check_incest_children,
    check_incest_marriage,
    check_same_sex_marriage,
    check_orphans,
    check_gender_consistency,
    check_marriage_consistency,
    check_duplicate_parents,
    format('═══════════════════════════════════════════════════════~n~n').