% ==============================================================================
% FAMILY TREE ANALYZER
% ==============================================================================
% A comprehensive Prolog system for family tree analysis and visualization
% TA : Mohammad Khoshroo
% Name : 
% SID:
% ==============================================================================

:- initialization(main, main).

:- ['rules.pl'].
:- ['validate.pl'].
:- ['visualize.pl'].

% --- Load All Modules ---
:- consult('rules.pl').
:- consult('validate.pl').
:- consult('visualize.pl').

% --- Load All Facts ---
:- consult('tests/t07.pl').


% --- Main Entry Point ---
main :-
    format('~n'),
    format('╔═══════════════════════════════════════════════════════╗~n'),
    format('║                                                       ║~n'),
    format('║         FAMILY TREE ANALYZER & VISUALIZER             ║~n'),
    format('║                                                       ║~n'),
    format('╚═══════════════════════════════════════════════════════╝~n'),
    run_full_analysis.

% --- Run Complete Analysis ---
run_full_analysis :-
    validate_all,
    print_statistics,
    export_family_graph('family_tree.dot'),
    format('~nAnalysis complete!~n~n').

% --- Quick Run (Skip Validation) ---
quick_run :-
    export_family_graph('family_tree.dot').

% --- Interactive Query Examples ---
show_examples :-
    format('~n'),
    format('═══════════════════════════════════════════════════════~n'),
    format('  EXAMPLE QUERIES~n'),
    format('═══════════════════════════════════════════════════════~n~n'),
    format('  Find all siblings of Bob:~n'),
    format('    ?- sibling(bob, X).~n~n'),
    format('  Find Bob\'s generation:~n'),
    format('    ?- generation(bob, N).~n~n'),
    format('  Find all ancestors of Henry:~n'),
    format('    ?- ancestor(X, henry).~n~n'),
    format('  Find all of Emma\'s cousins:~n'),
    format('    ?- cousin(emma, X).~n~n'),
    format('  Check if two people are married:~n'),
    format('    ?- spouse(alice, X).~n~n'),
    format('  Find all grandparents of Lily:~n'),
    format('    ?- grandparent(X, lily).~n~n'),
    format('═══════════════════════════════════════════════════════~n~n').

% --- Help Command ---
help :-
    format('~n'),
    format('═══════════════════════════════════════════════════════~n'),
    format('  AVAILABLE COMMANDS~n'),
    format('═══════════════════════════════════════════════════════~n~n'),
    format('  main.                  - Run full analysis~n'),
    format('  quick_run.             - Generate graph only~n'),
    format('  validate_all.          - Run all validations~n'),
    format('  print_statistics.      - Show family statistics~n'),
    format('  show_examples.         - Show query examples~n'),
    format('  help.                  - Show this help~n~n'),
    format('═══════════════════════════════════════════════════════~n~n').

% --- Welcome Message ---
:- format('~n'),
   format('  Welcome to Family Tree Analyzer!~n'),
   format('  Type "help." for available commands~n'),
   format('  Type "main." to run full analysis~n~n').


%  dot -Tsvg -Granksep=20.0 family_tree.dot -o family_tree.svg