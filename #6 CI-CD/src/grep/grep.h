#include <regex.h>

#include "struct_grep_meth.h"

void output(char **argv, FILE *file, struct grep_options *option, char *pattern,
            int filesCount);

void read_files(int argc, char *argv[], struct grep_options *option,
                char *pattern);
