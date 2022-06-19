% SWI Prolog


% ------------------------------------------------------------------------


pristavka_list(L):-L =
[
['з','а']:'за',
['и','з']:'из',
['в','ы']:'вы',
['о','б']:'об',
['п','е','р','е']:'пере',
['н','е','д','о']:'недо'
].


koren_list(L):-L =
[
['у','ч']:'уч'
].


okonchanie_list(L):-L =
[
['и','л']:'ил',
['и','т']:'ит',
['и','л','а']:'ила',
['и','л','о']:'ило',
['и','л','и']:'или'
].


rod_list(L):- L =
[
'а':'женский',
'о':'средний',
'л':'мужской',
'т':'мужской',
'и':'неопределенный'
].


chislo_list(L):- L =
[
'и':'множественное',
'а':'единственное',
'о':'единственное',
'л':'единственное',
'т':'единственное'
].


% ------------------------------------------------------------------------


an_morf(Word, morph(Pristavka, Koren, Okonchanie, Rod, Chislo)):-
	append(X, Okonch_suff, Word),
	append(Prist, Kor, X),
	is_pristavka(Prist, Pristavka),
	is_koren(Kor, Koren),
	is_okonchanie(Okonch_suff, Okonchanie),
	is_rod(Okonch_suff, Rod),
	is_chislo(Okonch_suff, Chislo),
	!.


% ------------------------------------------------------------------------


find(Y, X, L):-
	member(M, L),
	states(Y, X, M).


states(Y, X, X:Y).


is_pristavka(X, prist(X1)):-
	pristavka_list(L),
	find(X1, X, L).


is_koren(X, kor(X1)):-
	koren_list(L),
	find(X1, X, L).


is_okonchanie(X, okon(X1)):-
	okonchanie_list(L),
	find(X1, X, L).


is_rod([X], rod(X1)):-
	rod_list(L),
	find(X1, X, L).
is_rod([_|T], rod(X1)):-
	is_rod(T, rod(X1)).


is_chislo([X], chislo(Y)):-
	chislo_list(L),
	find(Y, X, L).
is_chislo([_|T], chislo(Y)):-
	is_chislo(T, chislo(Y)).


% ------------------------------------------------------------------------
