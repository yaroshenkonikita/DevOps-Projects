#include <getopt.h>
#include <string.h>

#include "end_err.h"
#define BUFFER_LEN 4096

struct grep_options *init_grep_option(char *pattern);

void flagF(char *pattern, int *eCount, struct grep_options *option);

void what_option(int argc, char **argv, struct grep_options *option,
                 char *pattern);
