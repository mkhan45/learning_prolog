strings_equal(S1, S2) :-
    string_chars(S1, C1),
    string_chars(S2, C2),
    check_letters(C1, C2).

check_letters([], []).
check_letters([H1|T1], [H2|T2]) :-
    H1 = H2,
    check_letters(T1, T2).

reverse_string(S, R) :-
    string_chars(S, SC),
    string_chars(R, RC),
    reverse_list(SC, RC).

reverse_list([], []).
reverse_list([H|T], R) :-
    reverse_list(T, RT),
    append(RT, [H], R).

palindrome(S) :- 
    reverse_string(S, S).
