
lines = load 'alice.txt';
words = foreach lines generate flatten(STRSPLITTOBAG($0, ' ', 0));
grwds = group words by $0;
counts = foreach grwds generate $0, COUNT($1);
store counts into 'word_counts' using PigStorage('\t');

