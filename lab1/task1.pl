%-----------------------------------------------------------
%strawberry prolog
%-----------------------------------------------------------
%-----------------------------------------------------------
%standart predicates
%-----------------------------------------------------------


length([], 0).
length([_|Y], N):-length(Y, N1), N is N1 + 1.


member(A, [A|_]).
member(A, [_|Z]):-member(A,Z).


append([], X, X).
append([A|X], Y, [A|Z]):-append(X, Y, Z).


remove(X, [X|T], T).
remove(X, [Y|T], [Y|T1]):-remove(X, T, T1).


permute([], []).
permute(L, [X|T]):-remove(X, L, R), permute(R, T).


sublist(S, L):-append(L1, L2, L), append(S, L3, L2).


list_min([L|Ls], Min) :-list_min(Ls, L, Min).
list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :- Min1 is min(L, Min0), list_min(Ls, Min1, Min).


%-----------------------------------------------------------
%truncating a list 1
%-----------------------------------------------------------


cutlist1(X, 0, []).
cutlist1([X|Y], N, [X|Z]):-N1 is N - 1, cutlist1(Y, N1, Z).


%-----------------------------------------------------------
%truncating a list 2
%-----------------------------------------------------------


cutlist2(X, N, R):-length(R, N), append(R, _, X).


%-----------------------------------------------------------
%minimum element and its index 1
%-----------------------------------------------------------


min_list1([X|Y], Min, Index):-
                             min_list1(Y, X, 0, 0, Min,Index).

min_list1([], Min, Index, Curr, Min, Index).

min_list1([X|Y], Min_prev, Prev, CurrIndex, Min, Index):-X < Min_prev,
                            NewIndex is CurrIndex + 1,
                            min_list1(Y, X, NewIndex, NewIndex, Min, Index).

min_list1([X|Y], Min_prev, OldIndex, CurrIndex, Min, Index):- X >= Min_prev,
                            NewIndex is CurrIndex + 1,
                            min_list1(Y, Min_prev, OldIndex, NewIndex, Min, Index).

%-----------------------------------------------------------
%minimum element and its index 2
%-----------------------------------------------------------


find([E|_], E, CurrIndex, CurrIndex).
find([X|Y], E, I, CurrIndex):-
                              NextIndex is CurrIndex + 1,
                              find(Y, E, I, NextIndex).


min_list2(L, E, I):-
                    list_min(L, E), find(L, E, I, 0).
