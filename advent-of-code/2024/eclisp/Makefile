ECLISP=~/dev/common-lisp/eclisp/eclisp

all: bin/day01

bin/day01: build/day01.c
	mkdir -p bin
	gcc -Ibuild $(CFLAGS) build/day01.c -O2 -o bin/day01

SOURCES = \
  day01.eclisp

X_FILES = $(addprefix build/,$(patsubst %.eclisp,%.X,$(SOURCES)))

.INTERMEDIATE: $(X_FILES)

build/macros.h: macros.eclisph

build/day01.X: day01.eclisp
build/day01.c: build/day01.X build/day01.h build/macros.h
build/day01.h: build/day01.X build/macros.h

%.c: %.X
	mkdir -p build
	sed -e 's/#include/%include/' $< > $@
	cpp -Ibuild -C $@ -o $@.i
	sed -i '1,/# [0-9]\{1,\} "<command-line>" 2/d' $@.i
	sed -i -e 's/^# [0-9]\{1,\}.*//' $@.i
	mv $@.i $@
	sed -i 's/%include/#include/' $@
	clang-format -i $@

%.h: %.X
	mkdir -p build
	sed -e 's/#include/%include/' $< > $@
	cpp -Ibuild -C -DPROCESS_HEADER $@ -o $@.i
	sed -i '3,/# 1 "<command-line>" 2/d' $@.i
	sed -i -e 's/^# [0-9]\{1,\}.*//' $@.i
	sed -i '1i#ifndef $(basename $(notdir $@))_H\n' $@.i
	sed -i '2i#define $(basename $(notdir $@))_H\n' $@.i
	echo '#endif' >> $@.i
	mv $@.i $@
	sed -i 's/%include/#include/' $@
	clang-format -i $@

build/%.X: %.eclisp
	mkdir -p build
	$(ECLISP) $^ > $@

build/%.h: %.eclisph
	mkdir -p build
	$(ECLISP) $^ > $@

.PHONY: clean
clean:
	rm -rf build

