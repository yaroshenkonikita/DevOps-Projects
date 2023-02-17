.PHONY: all cat grep test_cat test_grep getmod style

CAT=./src/s21_cat
GREP=./src/s21_grep
CAT_TEST=src/test_cat/test_func_cat.sh
GREP_TEST=src/test_grep/test_func_grep.sh

all: cat grep

cat:
	gcc -Wall -Werror -Wextra src/cat/*.c -o $(CAT)

grep:
	gcc -Wall -Werror -Wextra src/grep/*.c -o $(GREP)

getmod:
	chmod +x $(CAT_TEST) $(GREP_TEST)

test_cat: cat $(CAT) getmod
	bash $(CAT_TEST) $(CAT)

test_grep: grep $(GREP) getmod
	bash $(GREP_TEST) $(GREP)

clean:
	rm $(BUILD) ./src/test*/*.log

style:
	clang-format -n -style=google ./src/cat/* ./src/grep/*