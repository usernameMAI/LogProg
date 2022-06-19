%-----------------------------------------	--------------------

days_lie(chuk, [mon, tue, wed]).
days_lie(gek, [tue, thu, sat]).
days([mon, tue, wed, thu, fri, sat, sun]).

%------------------------------------------------------------- 

solve(Speaker, Friend, Day):-
	statement1(Speaker, sun, _, _, TF1), names(Speaker, Friend), statement2(Friend, _, fri, wed, TF2), ans(Speaker, TF1, Friend, TF2, Day).

%-------------------------------------------------------------

statement1(Name, Prev_day, _, Now_day, TF1):-
        now_next(Prev_day, Now_day),
        lie(chuk, Now_day),
        Name = gek, TF1 = yes, !;
        Name = chuk, TF1 = no.

statement2(Name, _, Next_day, Now_day, TF2):-
        lie(Name, Now_day),
        TF2 = yes, !;
        now_prev(Next_day, Now_day2),
        lie(Name, Now_day2),
        TF2 = yes, !;
        TF2 = no.

%-------------------------------------------------------------

prev(Now, Prev, [Prev|[Now|_]]):-!.
prev(Now, Prev, [_|T]):-
	 prev(Now, Prev, T).

now_prev(mon, sun):-!.
now_prev(Now, Prev):-
	days(X),
	prev(Now, Prev, X).

next(Now, Next, [Now|[Next|_]]):-!.
next(Now, Next, [_|T]):-
	next(Now, Next, T).

now_next(sun, mon):-!.
now_next(Now, Next):-
	days(X),
	next(Now, Next, X).

%-------------------------------------------------------------

ans(Name1, Lie1, Name2, Lie2, Day):-
	Lie1 = yes, Lie2 = yes,
	findall(Day1, lie(Name1, Day1), List1),
	findall(Day2, lie(Name2, Day2), List2),
	intersection(List1, List2, Day), !;

	Lie1 = yes, Lie2 = no,
        findall(Day1,lie(Name1, Day1), List1),
        findall(Day2,no_lies(Name2, Day2), List2),
        intersection(List1, List2, Day), !;

	Lie1 = no, Lie2 = yes,
        findall(Day1,no_lies(Name1, Day1), List1),
        findall(Day2,lies(Name2, Day2), List2),
        intersection(List1, List2, Day), !;

        Lie1 = no, Lie2 = no,
        findall(Day1,no_lies(Name1, Day1), List1),
        findall(Day2,no_lies(Name2, Day2), List2),
        intersection(List1, List2, Day), !.

no_lies(Name, Day):-
	lie(Name, List1),
	days(List2),
	subtract(List2, List1, NoDay),
	member(Day, NoDay).

names(chuk, gek).
names(gek, chuk).

lie(Name, Day):-
	days_lie(Name, Days),
	member(Day, Days).

%-------------------------------------------------------------
