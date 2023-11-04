sorted([]).
sorted([_]).
sorted([X,Y|T]) :- X =< Y, sorted([Y|T]).

sortedVersion(A, B) :-
    permutation(A, B),
    sorted(B).

halfsies([], [], []).
halfsies([X], [X], []).
halfsies([A,B|T], [A|L], [B|R]) :- halfsies(T, L, R).

mergeSorted([], []).
mergeSorted([X], [X]).
mergeSorted(List, SortedList) :-
    length(List, N), N > 1,
    halfsies(List, L, R),
    mergeSorted(L, SL),
    mergeSorted(R, SR),
    merged(SL, SR, SortedList).

merged([],L,L).
merged(L,[],L):-L\=[].
merged([X|TL],[Y|TR],[X|T]) :- X=<Y, merged(TL,[Y|TR],T).
merged([X|TL],[Y|TR],[Y|T]) :- X>Y, merged([X|TL],TR,T).
