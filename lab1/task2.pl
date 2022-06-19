% Task 2: Relational Data
% three.pl, вариант 1, SWI prolog

% The line below imports the data
:- ['three.pl'].


%--------------------------------------------------------------------------------
% Задание 1
% Получить таблицу групп и средний балл по каждой из групп
%--------------------------------------------------------------------------------

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



%--------------------------------------------------------------------------------
% Задание 2
% Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)
%--------------------------------------------------------------------------------


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


%------------------------------------------------------------------------------------
% Задание 3
% Найти количество не сдавших студентов в каждой из групп
%------------------------------------------------------------------------------------

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



%------------------------------------------------------------------------------------


%?-task1().
%?-task2().
%?-task3().

