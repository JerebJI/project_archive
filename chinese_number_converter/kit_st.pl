:-use_module(library(dcgs)).
:-use_module(library(clpz)).
:-use_module(library(lists)).
:-use_module(library(format)).

% za pretvorbo iz/v pinyin
pin([])-->"".
pin(["líng"|Ps])-->"零",pin(Ps).
pin(["yī"|Ps])-->"一",pin(Ps).
pin(["èr"|Ps])-->"二",pin(Ps).
pin(["liǎng"|Ps])-->"两",pin(Ps).
pin(["sān"|Ps])-->"三",pin(Ps).
pin(["sì"|Ps])-->"四",pin(Ps).
pin(["wǔ"|Ps])-->"五",pin(Ps).
pin(["liù"|Ps])-->"六",pin(Ps).
pin(["qī"|Ps])-->"七",pin(Ps).
pin(["bā"|Ps])-->"八",pin(Ps).
pin(["jiǔ"|Ps])-->"九",pin(Ps).
pin(["shí"|Ps])-->"十",pin(Ps).
pin(["bǎi"|Ps])-->"百",pin(Ps).
pin(["qiān"|Ps])-->"千",pin(Ps).
pin(["wàn"|Ps])-->"万",pin(Ps).
pin(["yì"|Ps])-->"亿",pin(Ps).

% za stevilke
st(0)-->"蕶".
st(1)-->"一".
st(2)-->"二".
st(3)-->"三".
st(4)-->"四".
st(5)-->"五".
st(6)-->"六".
st(7)-->"七".
st(8)-->"八".
st(9)-->"九".
st(10)-->"十".
st(100)-->"百".
st(1000)-->"千".
st(10000)-->"一",lst(10000).
st(100000000)-->"一",lst(100000000).

st(R)-->{R in 11..19, X in 0..9,            R#=10+X},     st(10),pst(X).
st(R)-->{R in 20..99, X in 1..9, Y in 0..9, R#=(X*10)+Y}, st(X),st(10),pst(Y).

st(R)-->{R in 101..999, X in 1..9, Y in 0..9,   R#=(X*100)+Y}, dst(X),st(100),st(0),st(Y).
st(R)-->{R in 101..999, X in 1..9, Y in 10..99, R#=(X*100)+Y}, dst(X),st(100),pst(Y).

st(R)-->{R in 1001..9999, X in 1..9, Y in 0..99,    R#=(X*1000)+Y}, dst(X),st(1000),st(0),pst(Y).
st(R)-->{R in 1001..9999, X in 1..9, Y in 100..999, R#=(X*1000)+Y}, dst(X),st(1000),pst(Y).

st(R)-->{R in 10001..999999999, X in 1..9999,                  R#=(X*10000)},   pst(X),lst(10000).
st(R)-->{R in 10001..999999999, X in 1..9999, Y in 1..999,     R#=(X*10000)+Y}, pst(X),lst(10000),st(0),pst(Y).
st(R)-->{R in 10001..999999999, X in 1..9999, Y in 1000..9999, R#=(X*10000)+Y}, pst(X),lst(10000),pst(Y).

st(R)-->{R in 100000001..999999999999, X in 1..9999,                        R#=(X*100000000)},   st(X),lst(100000000).
st(R)-->{R in 100000001..999999999999, X in 1..9999, Y in 1..9999,          R#=(X*100000000)+Y}, st(X),lst(100000000),st(0),pst(Y).
st(R)-->{R in 100000001..999999999999, X in 1..9999, Y in 10000..999999999, R#=(X*100000000)+Y}, st(X),lst(100000000),pst(Y).

% velike "stevke"
lst(10000)-->"万".
lst(100000000)-->"亿".

% ko obstajata dva razlicna zapisa dvojke
dst(2)--> "二" | "两" .
dst(R)-->{ R #\= 2 }, st(R).

% stevila, ko se enka ne izpusca in nicla izpusca
pst(0)-->"".
pst(R)-->{R in 1..9}, st(R).
pst(R)-->{R in 10..99, X in 1..9, Y in 0..9, R#=(X*10)+Y}, st(X),st(10),pst(Y).

pst(R)-->{R in 100..999, X in 1..9,              R#=(X*100)},   dst(X),st(100).
pst(R)-->{R in 100..999, X in 1..9, Y in 1..9,   R#=(X*100)+Y}, dst(X),st(100),st(0),pst(Y).
pst(R)-->{R in 100..999, X in 1..9, Y in 10..99, R#=(X*100)+Y}, dst(X),st(100),pst(Y).

pst(R)-->{R in 1000..9999, X in 1..999,                R#=(X*1000)},   dst(X),st(1000).
pst(R)-->{R in 1000..9999, X in 1..999, Y in 1..99,    R#=(X*1000)+Y}, dst(X),st(1000),st(0),pst(Y).
pst(R)-->{R in 1000..9999, X in 1..999, Y in 100..999, R#=(X*1000)+Y}, dst(X),st(1000),pst(Y).

pst(R)-->{R in 10000..999999999, X in 1..9999,                  R#=(X*10000)},   dst(X),lst(10000).
pst(R)-->{R in 10000..999999999, X in 1..9999, Y in 1..999,     R#=(X*10000)+Y}, dst(X),lst(10000),st(0),pst(Y).
pst(R)-->{R in 10000..999999999, X in 1..9999, Y in 1000..9999, R#=(X*10000)+Y}, dst(X),lst(10000),pst(Y).

% TODO: izpuscanje pri velikih stevilkah
% primeri uporabe:
% ?- phrase(st(25158067200), Pretvorba_v_kitajsko_stevilo).
% ?- phrase(st(Pretvorba_v_arabsko_stevilo), "八十三").
% ?- phrase(st(12), "十二"). %preveri, ce si pravilno pretvoril
% ?- phrase(("八",...,"三"),K), phrase(st(Arabsko),K). %najdi stevila, ki se zacnejo z 八 in koncajo z 三
% ?- phrase(("二",[X,Y],"四"),K), phrase(st(Arabsko),K). %dopolni s točno dvema znakoma

% helper predikati
arab_kit(A,K):-phrase(st(A),K).
kit_pin(K,P):-phrase(pin(P),K).
vzorec_kje(V,K):-phrase(V,K).
pomoc:-format("-- POMOC --~n~s -- ~s~n~s -- ~s~n~s -- ~s~n~s -- ~s~n~s -- ~s~n~s -- ~s~n~s -- ~s~n~s -- ~s~n~s -- ~s~n",
              ["halt.", "izhod iz programa",
               "arab_kit(1234,K).", "pretvorba arabskega stevila v kitajskega",
               "arab_kit(A,\"二十三\").", "pretvorba kitajskega stevila v arabskega",
               "arab_kit(10,\"十\").", "preveri pravilnost prevoda",
               "kit_pin(\"二十四\",P).","pretvori kitajsko stevilo v pinyin (ostale moznosti uporabe podobne kot pri arab_kit)",
               "arab_kit(1234,K), kit_pin(K,P).", "tako izgleda kombiniranje operacij",
               "arab_kit(Arabsko_stevilo, Kitajsko_stevilo).", "preglej vse mozne pretvorbe",
               "A, K, P, Arabsko_stevilo, ...", "lahko se uporabi za spremenljivko katerokoli ime, ki se zacne z veliko zacetnico",
               "vzorec_kje((\"三\", ... ,\"四\",[X,Y],\"一\"),K),arab_kit(A,K).", "poisci kitajsko stevilko, ki se zacne z 三, konca z 一 in cetrta pismenka od zadaj je 四."
              ]).
