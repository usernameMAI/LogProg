#№ Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Зубко Д. В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|    23.12     |        5      |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

Добавить таблицу сравнения поисков по времени, памяти, путям

## Введение

Какие задачи удобным образом решаются методом поиска в пространстве состояний? 
Почему Prolog оказывается удобным языком для решения таких задач?

Задачи, в которых присутствует дискретное множество состояний, хорошо решаются методом поиска в пространстве состояний. Множество состояний представляет собой набор различных состояний, между которыми можно осуществлять переход с помощью каких-то действий.
Поскольку язык Prolog основан на языке предикатов математической логики, он хорошо подходит для решения таких задач. 

## Задание

Вдоль доски расположены лунки, в каждой из которых лежит черный или белый шар. Одним ходом можно менять местами два соседних шара. Добиться того, чтобы сначала шли белые шары, а за ними - черные. Решить задачу за наименьшее число ходов.

## Принцип решения

Опишите своими словами принцип решения задачи, приведите важные фрагменты кода. Какие алгоритмы поиска вы использовали? 

В данной лабораторной работе я использовал 3 алгоритма поиска: поиск в глубину, поиск в ширину и поиск с итеративным погружением. Принцип решения -- идём по списку цветов шаров, перебираем их и проверяем, лежат ли они в правильном порядке. 

Используемые предикаты:

Вывод списка в обратном порядке

```
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
```

Поменять местами элементы, стоящие на M и N местах в списке L1.

```
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
```

Для проверки того, нужно ли менять два элемента списка местами. Белый шарик не должен быть впереди шарака чёрного цвета.

```
correct(L, A, B):-
    getNthElem(L, X, A),
    getNthElem(L, Y, B),
    X == black,
    Y == white, !.
```

Для перехода между состояниями в графе. Генерируются число от 0 до L1 с помощью предиката between, затем проверяется, правильно ли стоят элементы с меньшим порядковым индексом относительно элементов с большим индексом.

```
move(L, F):-
    length(L, Len),
    Len1 is Len - 1,
    between(0, Len1, A),
    B is A + 1,
    correct(L, A, B),
    swap(L, A, B, F).
```

Для того, чтобы предотвратить зацикливание поиска.

```
prolong([X|T], [Y, X|T]):-
    move(X, Y),
    not(member(Y, [X|T])).
```

Алгоритм dfs.

```
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
    
path1([X|T], X, [X|T]).
path1(P, Y, R):-
    prolong(P, P1),
    path1(P1, Y, R).
```

Алгоритм bfs.

```
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
```

Алгоритм search_id.

```
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
```

## Результаты

```
?- dfs([white, black, black, white, white, black, white], [white, white, white, white, black, black, black]).
DFS start
DFS finish
white, black, black, white, white, black, white
white, black, white, black, white, black, white
white, white, black, black, white, black, white
white, white, black, white, black, black, white
white, white, white, black, black, black, white
white, white, white, black, black, white, black
white, white, white, black, white, black, black
white, white, white, white, black, black, black
Solution in 7 steps
Time is 0.0010159015655517578
true.
```

```
?- bfs([white, black, black, white, white, black, white], [white, white, white, white, black, black, black]).
BFS start
BFS end
white, black, black, white, white, black, white
white, black, white, black, white, black, white
white, white, black, black, white, black, white
white, white, black, white, black, black, white
white, white, white, black, black, black, white
white, white, white, black, black, white, black
white, white, white, black, white, black, black
white, white, white, white, black, black, black
Solution in 7 steps
Time is 0.0050029754638671875
true.
```

```
?- search_id([white, black, black, white, white, black, white], [white, white, white, white, black, black, black]).
ITER start
ITER end
white, black, black, white, white, black, white
white, black, white, black, white, black, white
white, white, black, black, white, black, white
white, white, black, white, black, black, white
white, white, white, black, black, black, white
white, white, white, black, black, white, black
white, white, white, black, white, black, black
white, white, white, white, black, black, black
Solution in 7 steps
Time is 0.0030088424682617188
true.
```

## Выводы

Благодаря данной лабораторной работе я повторил алгоритмы поиска в глубину и ширину. Узнал о алгоритме с итерационным погружением, его преимущества и недостатки по сравнению с другими поисками. Познакомился с реализацией этих алгоритмов на языке Prolog. При решении задачи оптимальным оказался поиск в глубину, так как задача имеет единственное решение и поиск в глубину находит его быстрее других. Лабораторная работа заставила меня задуматься на тем, как я стал бы решать подобную задачу на других языках программирования, например, на Python или C++.


