isAtomic(N) :- number(N).
isAtomic(true).
isAtomic(false).

evaluatesTo(_, X, X) :- isAtomic(X).

evaluatesTo(Env, Var, Res) :-
    atom(Var),
    Res is Env.Var.

evaluatesTo(Env, [add, N1, N2], Res) :-
    evaluatesTo(Env, N1, LHS),
    evaluatesTo(Env, N2, RHS),
    number(LHS),
    number(RHS),
    Res is LHS + RHS.

evaluatesTo(Env, [sub, N1, N2], Res) :-
    evaluatesTo(Env, N1, LHS),
    evaluatesTo(Env, N2, RHS),
    number(LHS),
    number(RHS),
    Res is LHS - RHS.

evaluatesTo(Env, [mul, N1, N2], Res) :-
    evaluatesTo(Env, N1, LHS),
    evaluatesTo(Env, N2, RHS),
    number(LHS),
    number(RHS),
    Res is LHS * RHS.

evaluatesTo(Env, [div, N1, N2], Res) :-
    evaluatesTo(Env, N1, LHS),
    evaluatesTo(Env, N2, RHS),
    number(LHS),
    number(RHS),
    Res is LHS / RHS.

evaluatesTo(Env, [eq, N1, N2], Res) :-
    evaluatesTo(Env, N1, LHS),
    evaluatesTo(Env, N2, RHS),
    number(LHS),
    number(RHS),
    propToBool(LHS =:= RHS, Res).

evaluatesTo(Env, [lt, N1, N2], Res) :-
    evaluatesTo(Env, N1, LHS),
    evaluatesTo(Env, N2, RHS),
    number(LHS),
    number(RHS),
    propToBool(LHS < RHS, Res).

evaluatesTo(Env, [if, Cond, Then, _], Then) :- evaluatesTo(Env, Cond, true).
evaluatesTo(Env, [if, Cond, _, Else], Else) :- evaluatesTo(Env, Cond, false).

propToBool(X, true) :- X.
propToBool(X, false) :- not(X).

/* overflows */
failedSynth(P) :-
    evaluatesTo(env{x:1}, P, 1),
    evaluatesTo(env{x:2}, P, 2).
