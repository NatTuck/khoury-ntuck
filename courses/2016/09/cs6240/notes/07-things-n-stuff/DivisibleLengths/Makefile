
DivisibleLengths.jar: DivisibleLengths.java build.gradle Makefile
	gradle build
	gradle shadowJar
	cp build/libs/DivisibleLengths-all.jar DivisibleLengths.jar

run: DivisibleLengths.jar
	rm -rf output
	hadoop fs -rm -r /exercises/output
	hadoop jar DivisibleLengths.jar /exercises/input /exercises/output

clean:
	rm -rf build DivisibleLengths.jar output .gradle
