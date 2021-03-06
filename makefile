all : src/r3.o src/packetEncoder.o src/test/testLib src/r3Checker.o misc/r3.o

test : src/test/testSpmv
	cp src/test/runTestSpmv .
	cp src/test/testSpmv .
	cp src/test/run_simulation .
	runTestSpmv -vsim

test2 : src/test/testSpmv 
	cp src/test/runTestSpmv .
	cp src/test/testSpmv .
	cp src/test/run_simulation .
	runTestSpmv medExample.mtx

test3 : src/test/testChecker
	cp src/test/runTestChecker .
	cp src/test/testChecker .
	cp src/test/run_simulation .
	runTestChecker medExample.mtx

src/test/testChecker : src/test/testChecker.cpp src/packetEncoder.o src/r3.o src/mmio.o src/r3Checker.o
	cnyCC -I./include -o src/test/testChecker src/test/testChecker.cpp src/mmio.o src/packetEncoder.o src/r3.o src/cpSMVM.s src/r3Checker.o

src/test/testSpmv : src/test/testSpmv.cpp src/packetEncoder.o src/r3.o src/mmio.o src/r3Checker.o
	cnyCC -I./include -o src/test/testSpmv src/test/testSpmv.cpp src/mmio.o src/packetEncoder.o src/r3.o src/cpSMVM.s src/r3Checker.o

src/r3.o : src/r3.cpp 
	cnyCC -I./include -c -o src/r3.o src/r3.cpp

src/packetEncoder.o : src/packetEncoder.cpp
	cnyCC -I./include -c -o src/packetEncoder.o src/packetEncoder.cpp

src/mmio.o : src/mmio.c
	cnyCC -I./include -c -o src/mmio.o src/mmio.c

src/r3Checker.o : src/r3Checker.cpp
	cnyCC -I./include -O3 -c -o src/r3Checker.o src/r3Checker.cpp

misc/r3.o : src/r3.o src/mmio.o src/packetEncoder.o src/cpSMVM.s
	cp src/r3.o misc/r3.o

misc/mmio.o : src/mmio.o
	cp src/mmio.o misc/mmio.o

misc/packetEncoder.o : src/packetEncoder.o
	cp src/packetEncoder.o misc/packetEncoder.o

misc/cpSMVM.s : src/cpSMVM.s
	cp src/cpSMVM.s misc/cpSMVM.s

src/test/testLib : src/test/testLib.cpp misc/packetEncoder.o misc/cpSMVM.s misc/r3.o misc/mmio.o
	cnyCC -I./include misc/r3.o misc/packetEncoder.o misc/cpSMVM.s misc/mmio.o -o src/test/testLib src/test/testLib.cpp 
	
clean :
	rm -rf log src/*.o runTestSpmv testSpmv run_simulation src/test/testSpmv testChecker src/test/testChecker runTestChecker lib/* misc/*
	make -C sim clean

release : misc/r3.o misc/mmio.o misc/packetEncoder.o misc/cpSMVM.s 
	cp -r misc ${HOME}/
	cp -r include ${HOME}/
	cp -r personalities ${HOME}/

convey :
	cp src/test/runcp .
	scp ktown@linux-5.ece.iastate.edu:~/R3-0.0.0/src/test/testSpmv .
	runcp medExample
