#include <stdio.h>
#include <stdlib.h>

#define PROGRAM_NAME "grep"
#define PROGRAM_FLAGS "e:ivclnhsf:o"

void usage();

void malloc_fail();

void file_open_fail(char *name);
