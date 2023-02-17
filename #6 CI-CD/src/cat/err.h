#include <stdio.h>
#include <stdlib.h>

#define PROGRAM_NAME "cat"
#define PROGRAM_FLAGS "+benstvET" /*Au*/

void not_enough_arguments(int argc);

void usage();

void malloc_fail();

void file_open_fail(char *name);
