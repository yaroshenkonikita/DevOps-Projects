#include "struct_grep_meth.h"

struct grep_options *init_grep_option(char *pattern) {
  struct grep_options *options =
      (struct grep_options *)malloc(sizeof(struct grep_options));
  if (options == NULL) {
    free(pattern);
    malloc_fail();
  }
  options->pattern_for_match = false;
  options->ignore_case = false;
  options->invert_match = false;
  options->count = false;
  options->files_with_mathes = false;
  options->line_number = false;
  options->supp_filename = false;
  options->supp_err = false;
  options->obtain_patt_from_file = false;
  options->only_matching = false;
  return options;
}

void flagF(char *pattern, int *eCount, struct grep_options *option) {
  FILE *fp = NULL;
  char *buffer = (char *)calloc(sizeof(char), BUFFER_LEN);
  if (buffer == NULL) {
    close_all(NULL, pattern, option);
    malloc_fail();
  }
  if ((fp = fopen(optarg, "r"))) {
    while (fgets(buffer, BUFFER_LEN, fp) != NULL) {
      if (buffer[strlen(buffer) - 1] == '\n') {
        buffer[strlen(buffer) - 1] = 0;
      }
      if (*eCount > 0) {
        strcat(pattern, "|");
      }
      if (*buffer == '\0') {
        strcat(pattern, ".");
      } else {
        strcat(pattern, buffer);
      }
      *eCount += 1;
    }
    fclose(fp);
  } else {
    close_all(NULL, pattern, option);
    file_open_fail(optarg);
    free(buffer);
    exit(EXIT_FAILURE);
  }
  free(buffer);
}

void what_option(int argc, char **argv, struct grep_options *option,
                 char *pattern) {
  int flag, eCount = 0;
  while (
      ((flag = getopt_long(argc, argv, PROGRAM_FLAGS, NULL, NULL)) != (-1))) {
    switch (flag) {  // обработка всех опций, опция u игнорируется
      case 'e':
        if (eCount > 0) {
          strcat(pattern, "|");
        }
        strcat(pattern, optarg);
        option->pattern_for_match = true;  // useless
        eCount++;
        break;
      case 'i':
        option->ignore_case = true;
        break;
      case 'v':
        option->invert_match = true;
        break;
      case 'c':
        option->count = true;
        break;
      case 'l':
        option->files_with_mathes = true;
        break;
      case 'n':
        option->line_number = true;
        break;
      case 'h':
        option->supp_filename = true;
        break;
      case 's':
        option->supp_err = true;
        break;
      case 'f':
        option->obtain_patt_from_file = true;  // useless
        flagF(pattern, &eCount, option);
        break;
      case 'o':
        option->only_matching = true;
        break;
      default:
        if (option->supp_err) {
          usage();
        }
        close_all(NULL, pattern, option);
        exit(EXIT_FAILURE);
    }
  }
  if (eCount == 0) strcat(pattern, argv[optind++]);
  if (option->invert_match && option->only_matching)
    option->only_matching = false;
}
