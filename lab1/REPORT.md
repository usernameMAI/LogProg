# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Зубко Д.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|  20.12       |     4         |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение


  В языке Пролог список - это специальный вид терма, представляющий последовательность элементов - произвольных термов. Рекурсивная структура:
- либо пустой элемент;
- либо 1 элемент(голова) и присоединенный список(хвост).

Списки в языке Пролог напоминают односвязные списки из императивных языков.
В императивных языках, чаще всего, данные хранятся в массивах и имеют константную сложность доступа к элемернту, а добавление выполняется
за линейное время. Списки в Пролог очень похожи на списки в Python, поскольку они также могут содержать элементы разных типов.


## Задание 1.1: Предикат обработки списка

Стандартные предикаты:

`length([], 0).
 length([_|Y], N):-length(Y, N1), N is N1 + 1.`

`member(A, [A|_]).
 member(A, [_|Z]):-member(A,Z).`
 
`append([], X, X).
 append([A|X], Y, [A|Z]):-append(X, Y, Z).`
 
`remove(X, [X|T], T).
 remove(X, [Y|T], [Y|T1]):-remove(X, T, T1).`
 
`permute([], []).
 permute(L, [X|T]):-remove(X, L, R), permute(R, T)`
 
`sublist(S, L):-append(L1, L2, L), append(S, L3, L2).`

`list_min([L|Ls], Min) :-list_min(Ls, L, Min).
 list_min([], Min, Min).
 list_min([L|Ls], Min0, Min) :- Min1 is min(L, Min0), list_min(Ls, Min1, Min).`

`cutlist1(List, N, Result), cutlist2(List, N, Result)` - усечение списка List до длины N.

Примеры использования:
```Strawberry Prolog
?- cutlist1([1,2,3],2, Result), write(Result).
[1, 2]Yes.
?- cutlist2([1, 2, 3, 4 ,5], 3, Result), write(Result).
[1, 2, 3]Yes.
```

Реализация:
```Strawberry Prolog
%без стандартных предикатов
cutlist1(X, 0, []).
cutlist1([X|Y], N, [X|Z]):-N1 is N - 1, cutlist1(Y, N1, Z).
%со стандартными предикатами
cutlist2(X, N, R):-length(R, N), append(R, _, X).
```

`cutlist1(List, N, Result)` - рекурсивно добавляем в новый список по 1 элементу исходного, отсчитываем количество элементов,
которое осталось добавить.

`cutlist2(List, N, Result)` - копируем первые N элементов в новый список с помощью стандарьного предиката append.

## Задание 1.2: Предикат обработки числового списка

`min_list1(List, Min, Index), min_list2(List, Min, Index)` - поиск минимального элемента и его индекса.

Примеры использования:
```Strawberry Prolog
?-min_list1([1, 2, 0, 3], E, L), write(E), write(" "), write(L).
0 2Yes.
?-min_list2([1, 2, 0, 3, -1], E, L), write(E), write(" "), write(L).
-1 4Yes.
```

Реализация:
```Strawberry Prolog
%Реализация 1

min_list1([X|Y], Min, Index):-
                             min_list1(Y, X, 0, 0, Min,Index).

min_list1([], Min, Index, Curr, Min, Index).

min_list1([X|Y], Min_prev, Prev, CurrIndex, Min, Index):-X < Min_prev,
                            NewIndex is CurrIndex + 1,
                            min_list1(Y, X, NewIndex, NewIndex, Min, Index).

min_list1([X|Y], Min_prev, Prev_Index, CurrIndex, Min, Index):- X >= Min_prev,
                            NewIndex is CurrIndex + 1,
                            min_list1(Y, Min_prev, Prev_Index, NewIndex, Min, Index).
                            
%Реализация 2

find([E|_], E, CurrIndex, CurrIndex).
find([X|Y], E, I, CurrIndex):-
                              NextIndex is CurrIndex + 1,
                              find(Y, E, I, NextIndex).
                              
min_list2(L, E, I):-
                    list_min(L, E), find(L, E, I, 0).

```

`min_list1(List, Element, Index)` - запоминаем предыдущее минимальное число, его индекс, текущий индекс, текущее
минимальное число и его индекс. Сравниваем текущий элемент с хвостом.

`min_list2(List, Element, Index)` - находим с помощью стандартного предиката минимальный элемент в списке, а затем
с помощью предиката find индекс найденного минимального элемента.

## Задание 2: Реляционное представление данных

Представление данных в виде таблиц или отношений называется реляционным. 
Преимущества:
  -эта модель данных отображает информацию в наиболее простой для пользователя форме;
  -удобно хранить данные, менять их и добавлять;
  -легко узнавать связи тех или иных объектов.
Недостатки:
  -трудоемкость разработки;
  -медленный доступ к данным.
  
Преимущество представления three.pl: все данные о студенте (группа, имя, оценки) собраны в одном месте.
Недостаток: необходимость обработки лишних данных в некоторых предикатах.

Реализация:
```SWI Prolog
% Задание 1
% Получить таблицу групп и средний балл по каждой из групп


group_list(N, L):-findall(X, student(N, X, _), L).


grades_sum(N, Sum):-
                    findall(X, student(N, _, [grade('LP',X),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',_)]), LP),
                    findall(X, student(N, _, [grade('LP',_),grade('MTH',X),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',_)]), MTH),
                    findall(X, student(N, _, [grade('LP',_),grade('MTH',_),grade('FP',X),grade('INF',_),grade('ENG',_),grade('PSY',_)]), FP),
                    findall(X, student(N, _, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',X),grade('ENG',_),grade('PSY',_)]), INF),
                    findall(X, student(N, _, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',X),grade('PSY',_)]), ENG),
                    findall(X, student(N, _, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',X)]), PSY),
                    append(LP, MTH, A),
                    append(FP, INF, B),
                    append(ENG, PSY, C),
                    append(A, B, D),
                    append(D, C, L),
                    sum_list(L, Sum).


task1():-
          write("\nGroup101:  "), group_list(101, A), write(A),
          grades_sum(101, A_S), length(A, A_N), A_Ans is A_S / (A_N * 6), write("\nСредний балл: "), write(A_Ans),
          write("\nGroup102:  "), group_list(102, B), write(B),
          grades_sum(102, B_S), length(B, B_N), B_Ans is B_S / (B_N * 6), write("\nСредний балл: "), write(B_Ans),
          write("\nGroup103:  "), group_list(103, C), write(C),
          grades_sum(103, C_S), length(C, C_N), C_Ans is C_S / (C_N * 6), write("\nСредний балл: "), write(C_Ans),
          write("\nGroup104:  "), group_list(104, D), write(D),
          grades_sum(104, D_S), length(D, D_N), D_Ans is D_S / (D_N * 6), write("\nСредний балл: "), write(D_Ans), write("\n").



% Задание 2
% Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)


task2():-
         write("Students haven't passed LP: "), findall(X, student(_, X, [grade('LP',2),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',_)]), A),
         write(A), write("\n"),
         write("Students haven't passed MTH: "), findall(X, student(_, X, [grade('LP',_),grade('MTH',2),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',_)]), B),
         write(B), write("\n"),
         write("Students haven't passed FP: "), findall(X, student(_, X, [grade('LP',_),grade('MTH',_),grade('FP',2),grade('INF',_),grade('ENG',_),grade('PSY',_)]), C),
         write(C), write("\n"),
         write("Students haven't passed INF: "), findall(X, student(_, X, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',2),grade('ENG',_),grade('PSY',_)]), D),
         write(D), write("\n"),
         write("Students haven't passed ENG: "), findall(X, student(_, X, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',2),grade('PSY',_)]), E),
         write(E), write("\n"),
         write("Students haven't passed PSY: "), findall(X, student(_, X, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',2)]), F),
         write(F), write("\n").


% Задание 3
% Найти количество не сдавших студентов в каждой из групп


remove_duplicates([], []).
remove_duplicates([X|Xs], Ys):-
      member(X, Xs), remove_duplicates(Xs, Ys).
remove_duplicates([X|Xs], [X|Ys]):- remove_duplicates(Xs, Ys).


count(N, L):-
             findall(X, student(N, X, [grade('LP',2),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',_)]), A),
             findall(X, student(N, X, [grade('LP',_),grade('MTH',2),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',_)]), B),
             findall(X, student(N, X, [grade('LP',_),grade('MTH',_),grade('FP',2),grade('INF',_),grade('ENG',_),grade('PSY',_)]), C),
             findall(X, student(N, X, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',2),grade('ENG',_),grade('PSY',_)]), D),
             findall(X, student(N, X, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',2),grade('PSY',_)]), E),
             findall(X, student(N, X, [grade('LP',_),grade('MTH',_),grade('FP',_),grade('INF',_),grade('ENG',_),grade('PSY',2)]), F),
             append(A, B, X), append(C, D, Y), append(E, F, Z), append(X, Y, J), append(J, Z, M), remove_duplicates(M, P), length(P, L).



task3():-
         write("\nAmount of students haven't passed In 101 is "), count(101, A), write(A),
         write("\nAmount of students haven't passed in 102 is "), count(102, B), write(B),
         write("\nAmount of students haven't passed in 103 is "), count(103, C), write(C),
         write("\nAmount of students haven't passed in 104 is "), count(104, D), write(D).



```
Примеры использования:
```SWI Prolog

?- task1().
Group101:  [Петровский,Сидоров,Мышин,Безумников,Густобуквенникова]
Средний балл: 4
Group102:  [Петров,Ивановский,Биткоинов,Шарпин,Эксель,Текстописов,Криптовалютников,Азурин,Круглотличников]
Средний балл: 3.814814814814815
Group103:  [Сидоркин,Эфиркина,Сиплюсплюсов,Программиро,Клавиатурникова,Решетников,Текстописова,Вебсервисов]
Средний балл: 3.7708333333333335
Group104:  [Иванов,Запорожцев,Джаво,Фулл,Круглосчиталкин,Блокчейнис]
Средний балл: 3.888888888888889

?- task2().
Students haven't passed LP: []
Students haven't passed MTH: [Клавиатурникова,Блокчейнис,Азурин]
Students haven't passed FP: [Сидоркин,Мышин,Шарпин]
Students haven't passed INF: [Клавиатурникова,Текстописов,Блокчейнис]
Students haven't passed ENG: [Петровский,Круглосчиталкин]
Students haven't passed PSY: [Запорожцев,Сидоров,Мышин]

?- task3().
Amount of students haven't passed In 101 is 3
Amount of students haven't passed in 102 is 3
Amount of students haven't passed in 103 is 2
Amount of students haven't passed in 104 is 3
```

Список реализованных предикатов:

 `group_list(N, L)` - c помощью предиката findall находит всех студентов группы N.
 
 `grades_sum(N, Sum)` - с помощью предиката findall находит оценки студентов за предмет, 
 объединят с помощь append списки оценок за предметы, находит сумму всех оценок sum_list.
 
 `task1()` - выводит ответ на первое задание, использует предикаты group_list и grades_sum.
 
 `task2()` - выводит ответ на второе задание, с помощью findall находит студентов, получивших 2 по каждому предмету.
 
 `count(N, L)` - находит количество студентов в группе N, получивших 2 по предмету. Объединяет таких студентов в один список с помощью предиката append,
 убирает студентов, получивших больше двух двоек, с помощью предиката remove_duplicates().
 
 `remove_duplicates(M, P)` - убирает повторные элемента из списка M.
 
 `task3()` - выводит ответ на третье задание, использует предикат count(N, L).

## Выводы

Лабораторная работа помогла мне освоить синтаксис языка Prolog. Я узнал, что такое реляционные базы данных, их преимущества и недостатки. Ознакомился с двумя системами программирования на Prolog - Strawberry Prolog и SWI Prolog.
Познакомился с декларативным программированием на практике, в котором задаётся спецификация решения задача, то есть описывается, что представляет собой проблема и
ожидаемый результат.
Я задумался над тем, что из себя представляют списки в других языках программирования, например, в Python. Понял, что язык Prolog хорошо подходит для решения задач, где рассматриваются объекты и отношения между ними.




