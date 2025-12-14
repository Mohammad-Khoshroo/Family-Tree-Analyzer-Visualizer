# Family Tree Analyzer & Visualizer

A comprehensive Prolog-based system for family tree analysis, validation, and visualization.

## Project Structure

```
family-tree-prolog/
│
├── tests/              # Family data organized by generation
│   ├── t01.pl
│   ├── t01_v.pl        # the valid version of relations
│   ├── t02.pl
│   ├── t02_v.pl
│   ├── family_tree01.dot
│   ├── family_tree01_v.dot
│   ├── family_tree01.svg
│   ├── family_tree01_v.svg
│   ├── family_tree02.dot
│   ├── family_tree02_v.dot
│   ├── family_tree02.svg
│   └── family_tree02_v.svg
│
├── rules.pl           # Family relationship rules and logic
├── validation.pl      # Data validation and integrity checks
├── visualize.pl       # Graph generation and export
├── main.pl            # Main entry point
└── README.md          # This file
```

## Start

### 1. Run the program:
```bash
swipl main.pl
```

### 2. Available Commands:
```prolog
?- main.                  % Run full analysis with validation
?- quick_run.            % Generate graph only (skip validation)
?- validate_all.         % Run all data validations
?- print_statistics.     % Show family statistics
?- show_examples.        % Show example queries
?- help.                 % Show help menu
```

### 3. Generate visualization:
After running `main.` or `quick_run.`, convert the DOT file to SVG:
the `-Granksep=r` Specifies the vertical distance between ranks (layers) in the graph.  
```bash
 dot -Tsvg -Granksep=13.0 family_tree.dot -o family_tree.svg
```

## Example Queries

### Find relationships:
```prolog
?- sibling(bob, X).              % Find Bob's siblings
?- cousin(emma, X).              % Find Emma's cousins
?- grandparent(X, lily).         % Find Lily's grandparents
?- ancestor(X, henry).           % Find all ancestors of Henry
```

### Check generations:
```prolog
?- generation(bob, N).           % What generation is Bob?
?- generation(X, 3).             % Who is in generation 3?
```

### Marriage queries:
```prolog
?- spouse(alice, X).             % Who is Alice married to?
?- married(X, Y).                % List all marriages
```

## Validation Features

The system automatically checks for:
- **Incest detection**: Siblings having children together
- **Orphan detection**: Children with missing parents
- **Gender consistency**: People without assigned gender
- **Marriage consistency**: Parents not marked as married
- **Duplicate entries**: Redundant parent relationships

## Statistics

The system provides:
- Total number of people
- Male/Female distribution
- Number of marriages
- Generation depth
- Family tree completeness

## Visualization

The generated graph uses:
- **Blue nodes** for males
- **Pink nodes** for females
- **Solid arrows** for parent-child relationships
- **Dashed lines** for marriages
- **Hierarchical layout** by generation

by mohammad-Khoshroo
