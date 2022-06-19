% SWI prolog


% ------------------------------------------------------------------------
% ------------------------------------------------------------------------


% Рекурсивный вывод списка в обратном порядке.
revprint([]).
revprint([X|Y]):-
    revprint(Y),
    myprint(X), nl.

myprint([]).
myprint([X]):-
    write(X), !.
myprint([X|Y]):-
    write(X), write(", "),
    myprint(Y).


% Поменять местами элементы, стоящие на M и N местах, в списке L.
% Получится список L2.
swap(L1, M, N, L2):-
    length(L1, Len1),
    length(L2, Len2),
    Len1 =:= Len2,
    append(MH, [Mth|MT], L1),
    append(MH, [Nth|MT], Tmp),
    append(NH, [Nth|NT], Tmp),
    append(NH, [Mth|NT], L2),
    length(MH, M),
    length(NH, N), !.


% Получить элемент списка с номером N.
getNthElem([H|_],H,0):-!.
getNthElem([_|T],X,N):-
    N1 is N - 1,
    getNthElem(T, X, N1).


% Предикат нужен для проверки того, чтобы проверить, нужно ли менять два
% элемента.
correct(L, A, B):-
    getNthElem(L, X, A),
    getNthElem(L, Y, B),
    X == black,
    Y == white, !.


% Предикат нужен для переходов между состояниями в графе.
move(L, F):-
    length(L, Len),
    Len1 is Len - 1,
    between(0, Len1, A),
    B is A + 1,
    correct(L, A, B),
    swap(L, A, B, F).


% ------------------------------------------------------------------------
% ------------------------------------------------------------------------


% Поиск в глубину. X -- текущее состояние, Y -- искомое, P --
% последовательность состояний, приводящая X в Y.
dfs(X, Y):-
    write("DFS start"), nl,
    get_time(DFS_start),
    path1([X], Y, P),
    get_time(DFS_finish),
    write("DFS finish"), nl,
    revprint(P),
    length(P, S),
    S1 is S - 1,
    write("Solution in "), write(S1), write(" steps"), nl,
    write("Time is "),
    Time is DFS_finish - DFS_start,
    write(Time), nl, !.


prolong([X|T], [Y, X|T]):-
    move(X, Y),
    not(member(Y, [X|T])).


path1([X|T], X, [X|T]).
path1(P, Y, R):-
    prolong(P, P1),
    path1(P1, Y, R).


% ------------------------------------------------------------------------
% ------------------------------------------------------------------------


bfs(X, Y):-
    write("BFS start"), nl,
    get_time(BFS_start),
    bdth([[X]], Y, P),
    write("BFS end"), nl,
    get_time(BFS_finish),
    revprint(P),
    Time is BFS_finish - BFS_start,
    length(P, S),
    S1 is S - 1,
    write("Solution in "), write(S1), write(" steps"), nl,
    write("Time is "),
    write(Time), nl, !.

bdth([[X|T]|_], X, [X|T]).
bdth([P|QI], X, R):-
    findall(Z, prolong(P, Z), T),
    append(QI, T, QO),!,
    bdth(QO, X, R).
bdth([_|T], Y, L):-
    bdth(T, Y, L).


% ------------------------------------------------------------------------
% ------------------------------------------------------------------------


search_id(Start, Finish):-
    write("ITER start"), nl,
    get_time(ITR_start),
    integer1(Level),
    search_id(Start, Finish, Path, Level),
    get_time(ITR_end),
    write("ITER end"), nl,
    revprint(Path),
    Time is ITR_end - ITR_start,
    length(Path, S),
    S1 is S - 1,
    write("Solution in "), write(S1), write(" steps"), nl,
    write("Time is "), write(Time), nl, !.

integer1(1).
integer1(M):-integer1(N), M is N + 1.

search_id(Start, Finish, Path, DepthLimit):-
    depth_id([Start], Finish, Path, DepthLimit).

depth_id([Finish|T], Finish, [Finish|T], 0).
depth_id(Path, Finish, R, N):-
    N > 0,
    prolong(Path, NewPath), N1 is N - 1,
    depth_id(NewPath, Finish, R, N1).


% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
