.PHONY: test cloc debug write_build_type clean clean_nat

SRC := src
LIB := lib/natalie
OBJ := obj

BUILD := debug

cflags.debug := -g -Wall -Wextra -Werror -Wno-unused-parameter
cflags.release := -O3
CFLAGS := ${cflags.${BUILD}}

SOURCES := $(filter-out $(SRC)/main.c, $(wildcard $(SRC)/*.c))
OBJECTS := $(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(SOURCES))

NAT_SOURCES := $(wildcard $(SRC)/*.nat)
NAT_OBJECTS := $(patsubst $(SRC)/%.nat, $(OBJ)/nat/%.o, $(NAT_SOURCES))

build: write_build_type $(OBJECTS) $(NAT_OBJECTS) ext/onigmo/.libs/libonigmo.a

write_build_type:
	@echo $(BUILD) > .build

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -I$(SRC) -fPIC -c $< -o $@

$(OBJ)/nat/%.o: $(SRC)/%.nat
	bin/natalie --compile-obj $@ $<

ext/onigmo/.libs/libonigmo.a:
	cd ext/onigmo && ./autogen.sh && ./configure && make

clean_nat:
	rm -f $(OBJ)/*.o $(OBJ)/nat/*.o

clean: clean_nat
	cd ext/onigmo && make clean

test: build
	ruby test/all.rb

test_in_ubuntu:
	docker build -t natalie .
	docker run -i -t --rm --entrypoint make natalie test

cloc:
	cloc --not-match-f=hashmap.* --exclude-dir=.cquery_cache .
