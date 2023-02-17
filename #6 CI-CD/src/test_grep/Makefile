FOR TEST

.PHONY: all cat grep test_cat test_grep getmod style

CAT=cat_v-1
GREP=grep_v-1

all: cat grep

cat:
	gcc -Wall -Werror -Wextra cat/*.c -o $(CAT)

grep:
	gcc -Wall -Werror -Wextra grep/*.c -o $(GREP)

getmod:
	chmod +x ./test_cat/test_func_cat.sh ./test_grep/test_func_grep.sh

test_cat: cat $(CAT) getmod
	./test_cat/test_func_cat.sh ./$(CAT)

test_grep: grep $(GREP) getmod
	./test_grep/test_func_grep.sh ./$(GREP)

style:
	clang-format -n -style=google cat/* grep/*
	clang-format -i -style=google cat/* grep/*