#include <stdbool.h>

struct grep_options {
  bool pattern_for_match;      // pattern_for_match flag.e
  bool ignore_case;            // ignore_case flag.i
  bool invert_match;           // invert_match flag.v
  bool count;                  // count flag.c
  bool files_with_mathes;      // files_with_mathes flag.l
  bool line_number;            // line_number flag.n
  bool supp_filename;          // supp_filename flag.h
  bool supp_err;               // supp_err flag.s
  bool obtain_patt_from_file;  // obtain_patt_from_file flag.f
  bool only_matching;          // only_matching flag.o
};
