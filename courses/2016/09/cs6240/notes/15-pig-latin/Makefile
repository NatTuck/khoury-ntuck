
word_counts:
	pig -x local wordcount.pig

hof_by_year:
	pig -x local hofnames.pig

clean:
	rm -rf *.log word_counts hof_by_year
