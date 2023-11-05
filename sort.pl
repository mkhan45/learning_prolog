isSorted([]).
isSorted([_]).
isSorted([X,Y|T]) :- X =< Y, issorted([Y|T]).

naivelySorted(A, B) :-
    permutation(A, B),
    isSorted(B).

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
merged(L,[],L).
merged([X|TL],[Y|TR],[X|T]) :- 
    number(X), number(Y), X=<Y, 
    merged(TL,[Y|TR],T).
merged([X|TL],[Y|TR],[Y|T]) :- 
    number(X), number(Y), X>Y, 
    merged([X|TL],TR,T).

% I guess it infinite loops if the function is correct
checkMergeSort(L) :- 
    L = [_|_],
    mergeSorted(L, SortedL),
    not(isSorted(SortedL)).
