#include "err.h"

void usage() {
  fprintf(stderr, "usage: %s [-%s] [file ...]\n", PROGRAM_NAME, PROGRAM_FLAGS);
}

void malloc_fail() {
  fprintf(stderr, "%s: malloc fail", PROGRAM_NAME);
  exit(EXIT_FAILURE);
}

void file_open_fail(char *name) {
  fprintf(stderr, "%s: %s: No such file or directory\n", PROGRAM_NAME, name);
}
