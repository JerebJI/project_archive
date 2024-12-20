%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright (c) 2004-2005 Daniel L. Dudley
%  SPDX-License-Identifier: Apache-2.0
%
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/******************************************************************************

	Library: ISO8601.PL
	Copyright (c) 2004-2005 Daniel L. Dudley

	Purpose: ISO 8601 (and European civil calendar) compliant library of date
			 and time (clock) related predicates. That is, an ISO 8601 handler.

	Author:  Daniel L. Dudley
	Created: 2004-02-18

	Modified: 2014-09-26 (to use the library "os" object to get the current date)

******************************************************************************/

	/************************
	 ISO 8601 DATE PREDICATES
	 ************************/

	%==============================================================================
	% date(?JD, ?Year, ?Month, ?Day)

	date(JD,Year,Month,Day) :-
		(  var(JD), var(Year),  var(Month),  var(Day)
			-> % GET THE SYSTEM DATE AND ITS JULIAN DAY SERIAL NUMBER:
			os::date_time(Year, Month, Day, _, _, _, _)
			;  true
		),
		(  var(JD), nonvar(Year),  nonvar(Month),  nonvar(Day)
			-> % CORRIGATE BC/AD CALENDAR YEARS TO FIT 0-BASED ALGORITHM:
			(Year < 0 -> Year1 is Year + 1 ; Year1 = Year),
			% CONVERT DATE PARTS TO JULIAN DAY SERIAL NUMBER:
			A is (14 - Month) // 12,
			Y is Year1 + 4800 - A,
			M is Month + (12 * A) - 3,
			D is Day + ((153 * M + 2) // 5) + (365 * Y) + (Y // 4),
			JD is D - (Y // 100) + (Y // 400) - 32045
		;  nonvar(JD),
			% CONVERT JULIAN DAY SERIAL NUMBER TO DATE PARTS:
			A is JD + 32045,
			B is (4 * (A + 36524)) // 146097 - 1,
			C is A - ((146097 * B) // 4),
			D is ((4 * (C + 365)) // 1461) - 1,
			E is C - ((1461 * D) // 4),
			M is ((5 * (E - 1)) + 2) // 153,
			Day is E - (((153 * M) + 2) // 5),
			Month is M + (3 - (12 * (M // 10))),
			Year1 is ((100 * B) + D - 4800 + (M // 10)),
			% CORRIGATE 0-BASED ALGORITHM RESULT TO BC/AD CALENDAR YEARS:
			(Year1 < 1 -> Year is Year1 - 1 ;  Year = Year1)
		).


	%==============================================================================
	% date(?JD, ?Year, ?Month, ?Day, ?DoW)

	date(JD,Year,Month,Day,DoW) :-
		date(JD,Year,Month,Day),
		DoW is (JD mod 7) + 1.


	%==============================================================================
	% date(?JD, ?Year, ?Month, ?Day, ?DoW, ?Week)

	date(JD,Year,Month,Day,DoW,week(Wk,Yr)) :-
		(  var(JD), var(Year), var(Month), var(Day), nonvar(Wk), nonvar(Yr)
			-> (var(DoW) -> DoW = 1 ; true),
			date(JD1,Yr,1,1,DoW1),
			(DoW1 > 4 -> Offset = 0 ; Offset = 1),
			JD is JD1 + ((Wk - Offset) * 7) + DoW - DoW1,
			date(JD,Year,Month,Day)
		;  date(JD,Year,Month,Day,DoW),
			D4 is (((JD + 31741 - (JD mod 7)) mod 146097) mod 36524) mod 1461,
			L is D4 // 1460,
			Wk is (((D4 - L) mod 365) + L) // 7 + 1,
			% CORRIGATE YEAR AS NECESSARY:
			(  Month =:= 1, (Day =:= 1 ; Day =:= 2 ; Day =:= 3), Wk > 1
				-> Yr is Year - 1
			;  (  Month =:= 12, (Day =:= 29 ; Day =:= 30 ; Day =:= 31), Wk =:= 1
					-> Yr is Year + 1
				;  Yr = Year
				)
			)
		).


	%==============================================================================
	% date(?JD, ?Year, ?Month, ?Day, ?DoW, ?Week, ?DoY)

	date(JD,Year,Month,Day,DoW,Week,DoY) :-
		(	var(JD), nonvar(Year), (var(Month) ; var(Day)), nonvar(DoY)
			-> date(JD1,Year,1,0),
			JD is JD1 + DoY,
			date(JD,Year,Month,Day,DoW,Week)
		;	date(JD,Year,Month,Day,DoW,Week),
			date(JD1,Year,1,0),
			DoY is JD - JD1
		).


	%==============================================================================
	% date_string(+Format, ?Day, ?String)

	date_string('YYYYMMDD',Day,String) :-	% DATE
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,M0,M1,D0,D1]),
			  number_chars(Y,[Y0,Y1,Y2,Y3]),
			  number_chars(M,[M0,M1]),
			  number_chars(D,[D0,D1]),
			  Day = [Y,M,D]
		  ;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			  (Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; date(Day,Y,M,D)),
			  prepend_zeros(2,D,D1),
			  prepend_zeros(2,M,M1),
			  number_codes(Y,Y1),
			  list_of_lists_to_atom([Y1,M1,D1],String)
		).
	date_string('YYYY-MM-DD',Day,String) :-  % DATE
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,_,M0,M1,_,D0,D1]),
			  number_chars(Y,[Y0,Y1,Y2,Y3]),
			  number_chars(M,[M0,M1]),
			  number_chars(D,[D0,D1]),
			  Day = [Y,M,D]
		  ;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			  (Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; date(Day,Y,M,D)),
			  prepend_zeros(2,D,D1),
			  prepend_zeros(2,M,M1),
			  number_codes(Y,Y1),
			  list_of_lists_to_atom([Y1,[45],M1,[45],D1],String)
		).
	date_string('YYYY-MM',Day,String) :-	  % YEAR & MONTH
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,_,M0,M1]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  number_chars(Month,[M0,M1]),
			  Day = [Year,Month]
		  ;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,_) ; true),
			  (Day = [Y,M,_] -> nonvar(Y), nonvar(M) ; date(Day,Y,M,_)),
			  prepend_zeros(2,M,M1),
			  number_codes(Y,Y1),
			  list_of_lists_to_atom([Y1,[45],M1],String)
		).
	date_string('YYYY',Day,String) :-		  % YEAR
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  Day = [Year]
		;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,_,_) ; true),
			(Day = [Y|_] -> nonvar(Y) ; date(Day,Y,_,_)),
			number_codes(Y,Codes),
			atom_codes(String,Codes)
		).
	date_string('YY',Day,String) :-			% CENTURY
		( nonvar(String)
		  -> atom_chars(String,[C0,C1]),
			  number_chars(Century,[C0,C1]),
			  Day = [Century]
		;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,_,_) ; true),
			(Day = [Y|_] -> nonvar(Y) ; date(Day,Y,_,_)),
			Y1 is Y // 100,
			number_codes(Y1,Codes),
			atom_codes(String,Codes)
		).
	date_string('YYYYDDD',Day,String) :-	  % YEAR & DAY-OF-YEAR
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,D0,D1,D2]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  number_chars(DoY,[D0,D1,D2]),
			  Day = [Year,DoY]
		;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			(Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; JD = Day),
			date(JD,Y,M,D,_,_,DoY),
			prepend_zeros(3,DoY,DoY1),
			number_codes(Y,Y1),
			list_of_lists_to_atom([Y1,DoY1],String)
		).
	date_string('YYYY-DDD',Day,String) :-	% YEAR & DAY-OF-YEAR
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,_,D0,D1,D2]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  number_chars(DoY,[D0,D1,D2]),
			  Day = [Year,DoY]
		;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			(Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; JD = Day),
			date(JD,Y,M,D,_,_,DoY),
			prepend_zeros(3,DoY,DoY1),
			number_codes(Y,Y1),
			list_of_lists_to_atom([Y1,[45],DoY1],String)
		).
	date_string('YYYYWwwD',Day,String) :-	% YEAR, WEEK & DAY-OF-WEEK
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,_,W0,W1,DoW0]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  number_chars(Week,[W0,W1]),
			  number_chars(DoW,[DoW0]),
			  Day = [Year,Week,DoW]
		  ;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			  (Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; JD = Day),
			  date(JD,Y,M,D,DoW,week(Wk,Yr)),
			  number_codes(Yr,Y1),
			  prepend_zeros(2,Wk,Wk1),
			  number_codes(DoW,DoW1),
			  List = [Y1,[87],Wk1,DoW1],
			  list_of_lists_to_atom(List,String)
		).
	date_string('YYYY-Www-D',Day,String) :-  % YEAR, WEEK & DAY-OF-WEEK
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,_,_,W0,W1,_,DoW0]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  number_chars(Week,[W0,W1]),
			  number_chars(DoW,[DoW0]),
			  Day = [Year,Week,DoW]
		  ;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			  (Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; JD = Day),
			  date(JD,Y,M,D,DoW,week(Wk,Yr)),
			  number_codes(Yr,Y1),
			  prepend_zeros(2,Wk,Wk1),
			  number_codes(DoW,DoW1),
			  List = [Y1,[45,87],Wk1,[45],DoW1],
			  list_of_lists_to_atom(List,String)
		).
	date_string('YYYYWww',Day,String) :-	  % YEAR & WEEK
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,_,W0,W1]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  number_chars(Week,[W0,W1]),
			  Day = [Year,Week]
		  ;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			  (Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; JD = Day),
			  date(JD,Y,M,D,_,week(Wk,Yr)),
			  number_codes(Yr,Y1),
			  prepend_zeros(2,Wk,Wk1),
			  List = [Y1,[87],Wk1],
			  list_of_lists_to_atom(List,String)
		).
	date_string('YYYY-Www',Day,String) :-	% YEAR & WEEK
		( nonvar(String)
		  -> atom_chars(String,[Y0,Y1,Y2,Y3,_,_,W0,W1]),
			  number_chars(Year,[Y0,Y1,Y2,Y3]),
			  number_chars(Week,[W0,W1]),
			  Day = [Year,Week]
		  ;  ((var(Day) ; Day = [Y|_], var(Y)) -> date(_,Y,M,D) ; true),
			  (Day = [Y,M,D] -> nonvar(Y), nonvar(M), nonvar(D) ; JD = Day),
			  date(JD,Y,M,D,_,week(Wk,Yr)),
			  number_codes(Yr,Y1),
			  prepend_zeros(2,Wk,Wk1),
			  List = [Y1,[45,87],Wk1],
			  list_of_lists_to_atom(List,String)
		).


	%-----------------------------------
	% prepend_zeros(+Digits, +N, -Codes)
	% Purpose: prepend zeros to a given integer
	% Parameters:
	%  Digits: required number of digits to be entered into Codes
	%  N:  integer to which zeros are prepended
	%  Codes:  the resulting list of codes
	% Called by: date_string/3
	% Examples:
	%  ?- prepend_zeros(2,2,Codes).  => Codes = [48,50]
	%  ?- prepend_zeros(2,22,Codes). => Codes = [50,50]
	%  ?- prepend_zeros(3,2,Codes).  => Codes = [48,48,50]
	%  ?- prepend_zeros(3,22,Codes). => Codes = [48,50,50]

	prepend_zeros(2, I, Codes) :-
		number_codes(I, ICodes),
		two_codes(ICodes, Codes).
	prepend_zeros(3, I, Codes) :-
		number_codes(I, ICodes),
		three_codes(ICodes, Codes).

	two_codes([A], [48, A]) :- !.
	two_codes([A, B], [A, B]).

	three_codes([A], [48, 48, A]) :- !.
	three_codes([A, B], [48, A, B]) :- !.
	three_codes([A, B, C], [A, B, C]).

	%---------------------------------------
	% list_of_lists_to_atom(+Llist, -String)
	% Purpose: Convert a list of code lists to a string
	% Called by: date_string/3

	list_of_lists_to_atom(Llist,String) :-
		flatten(Llist,Codes),
		atom_codes(String,Codes).

	%------------------------------
	% flatten(+Llist, -Codes)
	% Purpose: Convert a list of lists to a list of codes
	% Note: custom, simplified version
	% Called by: list_of_lists_to_atom/2

	flatten([], []).
	flatten([[]| Ls], F) :-
		!,
		flatten(Ls, F).
	flatten([[H| T]| Ls], [H| Fs]) :-
		flatten([T| Ls], Fs).



	/**********************************
	 MISCELLANEOUS PREDICATES (GOODIES)
	 **********************************/

	%==============================================================================
	% valid_date(+Year, +Month, +Day)

	valid_date(Year,Month,Day) :-
		Month > 0,  Month < 13,
		Day > 0,
		(  Month =:= 2
			-> (leap_year(Year) -> Days = 29 ;  Days = 28)
		;  days_in_month(Month,Days)
		),
		Day =< Days.


	%==============================================================================
	% leap_year(+Year)

	leap_year(Year) :-
		(var(Year) -> date(_,Year,_,_) ; true),
		(Year < 0 -> Year1 is Year + 1 ; Year1 = Year),
		0 =:= Year1 mod 4,
		(0 =\= Year1 mod 100 -> true ;  0 =:= Year1 mod 400).


	%==============================================================================
	% calendar_month(?Year, ?Month, -Calendar)

	calendar_month(Year,Month,m(Year,Month,Weeks)) :-
		(var(Year), var(Month) -> date(_,Year,Month,_) ; true),
		% COMPUTE THE BODY (A 6 ROW BY 8 COLUMN TABLE OF WEEK AND DAY NUMBERS):
		date(JD,Year,Month,1,DoW,week(Week,_)),
		Lead0s is DoW - 1,  % number of leading zeros required
		( Month =:= 2
		  -> (leap_year(Year) -> Days = 29 ;  Days = 28)
		  ;  days_in_month(Month,Days)
		),
		Delta is 42 - (Lead0s + Days),	% number of trailing zeros required
		zeros(Delta,[],Append),		 % zeros to be appended to day list
		day_list(Days,Append,DList),  % create padded daylist
		zeros(Lead0s,DList,DayList),  % prepend zeros to padded day list
		Julian is JD - Lead0s,
		week_list(6,Julian,Week,DayList,Weeks).

	%-------------------------------
	% zeros(+Counter, +Build, -List)
	% Purpose: Prepend or append a list of 0's (zeros) to a given list
	% Called by: calendar_month/3

	zeros(0,L,L) :- !.
	zeros(DoW,Build,List) :-
		Next is DoW - 1,
		zeros(Next,[0|Build],List).

	%-------------------------------------
	% day_list(+Counter, +Build, -DayList)
	% Purpose: Return a list of day #s
	% Called by: calendar_month/3

	day_list(0,DayList,DayList) :- !.
	day_list(N,SoFar,DayList) :-
		N1 is N - 1,
		day_list(N1,[N|SoFar],DayList).

	%-------------------------------------------
	% week_list(+N, +JD, +Week, +Days, -WeekList)
	% Purpose: Return a list of week and day #s
	% Called by: calendar_month/3

	week_list(0,_,_,_,[]).
	week_list(N,JD,Week,Days,[X|Weeks]) :-
		Days = [F1,F2,F3,F4,F5,F6,F7|Days1],
		(  N < 3,
			F1 =:= 0
			-> Wk = 0
		;  Wk = Week
		),
		X = w(Wk,[F1,F2,F3,F4,F5,F6,F7]),
		JD1 is JD + 7,
		(  Week > 51
			-> date(JD1,_,_,_,_,week(Week1,_))
		;  Week1 is Week + 1
		),
		N1 is N - 1,
		week_list(N1,JD1,Week1,Days1,Weeks).


	%==============================================================================
	% easter_day(?Year, -Month, -Day)

	easter_day(Year,Month,Day) :-
		(nonvar(Year) -> true ; date(_,Year,_,_)),
		Year > 1582,
		A is Year mod 19,
		B is Year mod 4,
		C is Year mod 7,
		calc_M_and_N(Year,M,N),
		D is (19 * A + M) mod 30,
		E is ((2 * B) + (4 * C) + (6 * D) + N) mod 7,
		R is 22 + D + E,
		calc_month_and_day(R,Month,Day1),
		corr_day(Day1,Month,A,D,E,Day).

	%----------------------------
	% calc_M_and_N(+Year, -M, -N)
	% Purpose: Calculate intermediate values M and N
	% Called by: easter_day/3

	calc_M_and_N(Year,M,N) :-
		T is Year // 100,
		P is (13 + 8 * T) // 25,
		Q is T // 4,
		M is (15 + T - P - Q) mod 30,
		N is (T - (T // 4) + 4) mod 7.

	%-------------------------------------
	% calc_month_and_day(+R, -Month, -Day)
	% Purpose: Calculate the Easter Sunday month and likely day
	% Called by: easter_day/3

	calc_month_and_day(R,4,Day) :-  % April
		R > 31,
		!,
		Day is R - 31.
	calc_month_and_day(R,3,R).	% March

	%---------------------------------------------------
	% corr_day(+PossDay, +Month, +A, +D, +E, -ActualDay)
	% Purpose: Calculate the actual Easter Sunday
	% Called by: easter_day/3

	corr_day(_,4,_,29,6,19) :-  % April, Gregorian exception 1
		!.
	corr_day(_,4,A,28,6,18) :-  % April, Gregorian exception 2
		A > 10,
		!.
	corr_day(Day,_,_,_,_,Day).  % Otherwise



	/************************
	 LOCAL UTILITY PREDICATES
	 ************************/

	%------------------------------------
	% days_in_month(+Month, -DaysInMonth)
	% Purpose: Return the number of days in a given month
	% Called by: valid_date/3, calendar_month/3

	days_in_month( 1, 31).
	days_in_month( 2, 28).
	days_in_month( 3, 31).
	days_in_month( 4, 30).
	days_in_month( 5, 31).
	days_in_month( 6, 30).
	days_in_month( 7, 31).
	days_in_month( 8, 31).
	days_in_month( 9, 30).
	days_in_month(10, 31).
	days_in_month(11, 30).
	days_in_month(12, 31).
