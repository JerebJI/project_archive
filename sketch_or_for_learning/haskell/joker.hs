import Data.List.Unique

v = ["PUTER", "REP", "PETER", "PUDER", "VETER", "REK", "METER", "PETER", "PUFER", "RES"]
gen b = s b []
    where s [] _ = []
          s z  k = ((init z)++('?':k)):(s (init z) ((last z):k))
rez = count$concat$map (gen) v
