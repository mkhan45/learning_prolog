isAtomic(N) :- number(N).
isAtomic(true).
isAtomic(false).
isAtomic([fn, X, _]) :- atom(X).

evaluatesTo(X, X) :- isAtomic(X).

evaluatesTo([add, N1, N2], N) :- 
    evaluatesTo(N1, LHS), evaluatesTo(N2, RHS),
    number(LHS), number(RHS),
    N is LHS + RHS.

evaluatesTo([sub, N1, N2], N) :-
    evaluatesTo(N1, LHS), evaluatesTo(N2, RHS),
    number(LHS), number(RHS),
    N is LHS - RHS.

evaluatesTo([mul, N1, N2], N) :-
    evaluatesTo(N1, LHS), evaluatesTo(N2, RHS),
    number(LHS), number(RHS),
    N is LHS * RHS.

evaluatesTo([eq, N1, N2], Res) :-
    evaluatesTo(N1, LHS), evaluatesTo(N2, RHS),
    number(LHS), number(RHS),
    propToBool((LHS =:= RHS), Res).

evaluatesTo([lt, N1, N2], Res) :-
    evaluatesTo(N1, LHS), evaluatesTo(N2, RHS),
    number(LHS), number(RHS),
    propToBool(LHS < RHS, Res).

evaluatesTo([if, Cond, Then, _], Then) :- evaluatesTo(Cond, true).
evaluatesTo([if, Cond, _, Else], Else) :- evaluatesTo(Cond, false).

evaluatesTo([fn, X, Body], [fn, X, Body]).
evaluatesTo([app, Fn, Arg], Res) :-
    evaluatesTo(Fn, [fn, X, Body]),
    evaluatesTo(Arg, ArgVal),
    subst(Body, X, ArgVal, Substed),
    evaluatesTo(Substed, Res).

evaluatesTo([X], Res) :- evaluatesTo(X, Res).
evaluatesTo([[X, Expr], Rest], Res) :-
    evaluatesTo(Expr, ExprVal),
    subst(Rest, X, ExprVal, Substed),
    evaluatesTo(Substed, Res).

subst(X, X, Y, Y) :- atom(X).
subst(X, NX, _, X) :- atom(X), atom(NX), X \= NX.
subst(X, _, _, X) :- isAtomic(X).
subst([Op, LHS, RHS], Var, Subst, [Op, NewLHS, NewRHS]) :-
    subst(LHS, Var, Subst, NewLHS),
    subst(RHS, Var, Subst, NewRHS).
subst([if, Cond, Then, Else], Var, Subst, [if, NewCond, NewThen, NewElse]) :-
    subst(Cond, Var, Subst, NewCond),
    subst(Then, Var, Subst, NewThen),
    subst(Else, Var, Subst, NewElse).

subst([fn, X, Body], X, _, [fn, X, Body]).
subst([fn, X, Body], Var, Subst, [fn, X, NewBody]) :-
    X \= Var,
    subst(Body, Var, Subst, NewBody).

subst([app, Fn, Arg], Var, Subst, [app, NewFn, NewArg]) :-
    subst(Fn, Var, Subst, NewFn),
    subst(Arg, Var, Subst, NewArg).

propToBool(X, true) :- X.
propToBool(X, false) :- not(X).

factEvaluatesTo(X, Res) :-
    Fact = [fn, x, [if, [lt, x, 1], 1, [mul, x, [app, fact, [sub, x, 1]]]]],
    Prog = [[fact, Fact], [app, fact, X]],
    evaluatesTo(Prog, Res).
