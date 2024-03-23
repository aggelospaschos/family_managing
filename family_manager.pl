% We declare dynamic predicates 

:- dynamic(person/3).                                      % Represent family members with their roles and professions
:- dynamic(profession/1).                                  % Declare for representing professions

% We initialize a database

person(bob, father, _).                                    % Family members and their roles (father, mother, son, daughter)
person(alice, mother, _).
person(charlie, son, _).
person(david, son, _).
person(emily, daughter, _).
person(fred, daughter, _).

profession(smith).                                         % Available professions
profession(baker).
profession(carpenter).
profession(tailor).

% We define constraints for assigning professions to family members

all_different([]).                                         % Base case: All elements in a list are different
all_different([H | T]) :-                                  % Check if all elements in a list are different using recursion
    not(member(H, T)),                                     % Ensure that H is not a member of the tail T
    all_different(T).

% We assign professions to family members based on constraints

assign_professions(Father, Mother, Son, Daughter, SonProf, DaughterProf) :-
    profession(Father),                                      % Father must have a valid profession
    profession(Mother),                                      % Mother must have a valid profession
    profession(SonProf),                                     % Son's profession must be valid
    profession(DaughterProf),                                % Daughter's profession must be valid
    all_different([Father, Mother, SonProf, DaughterProf]),  % Ensures all professions are different
    Father \= SonProf,                                       % Father cannot have the same profession as his son
    Mother \= DaughterProf,                                  % Mother cannot have the same profession as her daughter
    SonProf \= smith,                                        % Son cannot be a smith
    DaughterProf \= tailor,                                  % Daughter cannot be a tailor
    SonProf = baker,                                         % Son must be a baker
    DaughterProf \= tailor,                                  % Daughter cannot be a tailor

    % We ensure that no two individuals have the same profession

    Father \= Mother,               
    Father \= SonProf,
    Father \= DaughterProf,
    Mother \= SonProf,
    Mother \= DaughterProf,
    SonProf \= DaughterProf.

% We define the family tree using compound terms

parent(bob, alice).                                          % Parent-child relationships
parent(alice, charlie).
parent(charlie, david).
parent(bob, emily).
parent(alice, fred).

% We find all descendants of an individual using recursion 

descendant(X, Y) :-                                          % Base case: Direct parent-child relationship
    parent(X, Y).
descendant(X, Y) :-                                          % We find descendants through intermediate generations 
    parent(X, Z), 
    descendant(Z, Y).

% Start the dialogue

start :-
    write('Welcome to the Family Professions program!'), nl,
    menu.

% Menu options

menu :-
    nl,
    write('1. Assign Professions to Family Members'), nl,
    write('2. Find Descendants of a Family Member'), nl,
    write('3. Sort a List (Naive, Insertion, Quick)'), nl,
    write('4. Path Finding in a Directed Graph'), nl,
    write('5. Exit'), nl,
    read_choice(Choice),
    process_choice(Choice),
    (Choice = 5 ->
        write('Exiting...'), nl;
        menu
    ).

% Process user's choice

process_choice(1) :-                                         % Assign professions to family members
    assign_professions_to_family_members,
    !.

process_choice(2) :-                                         % Find descendants of a family member
    find_descendants,
    !.

process_choice(3) :-                                         % Test sorting algorithms
    test_sorting_algorithms,
    !.

process_choice(4) :-                                         % Test path finding in a directed graph
    test_path_finding,
    !.

process_choice(5) :-                                        % Exit the program
    !.

% Read user's choice

read_choice(Choice) :-
    repeat,
    write('Enter your choice: '),
    read(Choice),
    member(Choice, [1,2,3,4,5]),
    !.

% We assign professions to family members

assign_professions_to_family_members :-
    person(bob, father, FatherProf),                        % Get father's current profession
    person(alice, mother, MotherProf),                      % Get mother's current profession
    person(charlie, son, SonProf),                          % Get son's current profession
    person(emily, daughter, DaughterProf),                  % Get daughter's current profession
    assign_professions(FatherProf, MotherProf, SonProf, DaughterProf, SonProf, DaughterProf),       % Assign new professions based on constraints
    retract(person(bob, father, _)),                        % Remove old profession records
    retract(person(alice, mother, _)),
    retract(person(charlie, son, _)),
    retract(person(emily, daughter, _)),
    asserta(person(bob, father, FatherProf)),               % Assert new profession records
    asserta(person(alice, mother, MotherProf)),
    asserta(person(charlie, son, SonProf)),
    asserta(person(emily, daughter, DaughterProf)),
    write('Professions assigned successfully!'), nl.

% We find descendants of a family member

find_descendants :-
    write('Enter the name of the family member: '), nl,
    read(Name),
    write('Descendants of '), 
    write(Name), 
    write(': '), nl,
    findall(Descendant, 
        descendant(Name, Descendant), 
        Descendants),                                 % Find all descendants of the given family member
    write_descendants(Descendants),
    nl.

% Write descendants to the console

write_descendants([]) :- !.
write_descendants([Descendant]) :-
    write('- '), 
    write(Descendant), nl.
write_descendants([Descendant|Rest]) :-
    write('- '), 
    write(Descendant), nl,
    write_descendants(Rest).

% Test sorting algorithms

test_sorting_algorithms :-
    write('Enter a list of numbers separated by commas: '), nl,
    read(List),
    write('Naive Sort: '), nl,
    naivesort(List, Sorted1),          % Naive sorting
    write(Sorted1), nl,
    write('Insertion Sort: '), nl,
    insertsort(List, Sorted2),         % Insertion sorting
    write(Sorted2), nl,
    write(Sorted2), nl,
    write('Quick Sort: '), nl,
    quicksort(List, Sorted3),          % Quick sorting
    write(Sorted3), nl.

% Test path finding in a directed graph

test_path_finding :-
    write('Enter the start node: '), nl,
    read(Start),
    write('Enter the end node: '), nl,
    read(End),
    find_path(
        Start, 
        End, 
        Path, 
        Cost),                         % Find a path from start to end in the directed graph
    write('Path: '), 
    write(Path), nl,
    write('Cost: '), 
    write(Cost), nl.

% Entry point
:- initialization(start, main).
