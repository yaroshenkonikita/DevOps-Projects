#include "struct_cat_meth.h"

struct cat_options *_init_cat_option() {
  struct cat_options *options = malloc(sizeof(struct cat_options));
  if (options == NULL) {
    malloc_fail();
  }
  options->number_nonblank_lines = false;
  options->number_lines = false;
  options->squeeze_blank = false;
  options->show_ends = false;
  options->non_print = false;
  options->show_tabs = false;
  return options;
}
