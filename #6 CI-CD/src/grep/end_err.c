#include "end_err.h"

void close_all(FILE *fp, char *pattern, struct grep_options *option) {
  if (fp != NULL) {
    fclose(fp);
  }
  if (pattern != NULL) {
    free(pattern);
  }
  if (option != NULL) {
    free(option);
  }
}
