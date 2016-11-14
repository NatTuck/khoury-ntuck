
pp0 = load 'baseball/Master.csv' using PigStorage(',');
pp1 = foreach pp0 generate $0, $15, $14;

hh0 = load 'baseball/HallOfFame.csv' using PigStorage(',');
hh1 = foreach hh0 generate $0, $1;

ff0 = join pp1 by $0, hh1 by $0;
ff1 = foreach ff0 generate $4, CONCAT($1, ' ', $2);

store ff1 into 'hof_by_year' using PigStorage(',');

