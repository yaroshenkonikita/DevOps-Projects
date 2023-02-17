#include <getopt.h>

#include "struct_cat_meth.h"

struct cat_options *what_option(int argc, char *argv[]);

void printNumberLine(int *number);

void output(FILE *filestream, struct cat_options options);

void open_files(int argc, char *argv[], struct cat_options options);
