#include "grep.h"

int main(int argc, char **argv) {
  if (argc < 3) {
    usage();
    exit(EXIT_FAILURE);
  }
  char *pattern = (char *)calloc(sizeof(char), BUFFER_LEN);
  if (pattern == NULL) {
    malloc_fail();
  }
  struct grep_options *option = init_grep_option(pattern);
  what_option(argc, argv, option, pattern);
  read_files(argc, argv, option, pattern);

  close_all(NULL, pattern, option);

  return 0;
}

void output(char **argv, FILE *file, struct grep_options *option, char *pattern,
            int filesCount) {
  regex_t re;
  int cflags = REG_EXTENDED;
  int pmatch = 1;
  regmatch_t regmatch[1] = {0};
  int status;
  char *buffer = (char *)calloc(sizeof(char), BUFFER_LEN);
  if (buffer == NULL) {
    close_all(file, pattern, option);
    malloc_fail();
    exit(EXIT_FAILURE);
  }
  size_t number_string = 1;
  int count_flag_c = 0;
  if (option->ignore_case) {
    cflags = REG_ICASE;
  }
  regcomp(&re, pattern, cflags);
  while (!feof(file)) {
    if (fgets(buffer, BUFFER_LEN, file)) {
      int is_new_line = 1;
      status = regexec(&re, buffer, pmatch, regmatch, 0);
      if (option->invert_match) {
        status = !status;
      }
      if (status != REG_NOMATCH) {
        if (!option->count && !option->files_with_mathes) {
          if (!option->supp_filename && filesCount > 1) {
            printf("%s:", argv[optind]);
          }
          if (option->line_number) {
            printf("%lu:", number_string);
          }
          if (option->only_matching && !option->invert_match) {
            is_new_line = 0;
            char *ptr = buffer;
            while (!status) {
              printf("%.*s\n", (int)(regmatch[0].rm_eo - regmatch[0].rm_so),
                     ptr + regmatch[0].rm_so);
              ptr += regmatch[0].rm_eo;
              status = regexec(&re, ptr, pmatch, regmatch, REG_NOTBOL);
            }
          }
          if (!option->only_matching) {
            printf("%s", buffer);
          }
          if (buffer[strlen(buffer) - 1] != '\n' && is_new_line) {
            printf("\n");
          }
        }
        ++count_flag_c;
      }
      ++number_string;
    }
  }
  free(buffer);
  regfree(&re);
  if (option->count) {
    if (!option->supp_filename && filesCount > 1) {
      printf("%s:", argv[optind]);
    }
    if (option->files_with_mathes && count_flag_c) {
      printf("1\n");
    } else {
      printf("%d\n", count_flag_c);
    }
  }
  if (option->files_with_mathes && count_flag_c) {
    printf("%s\n", argv[optind]);
  }
}

void read_files(int argc, char *argv[], struct grep_options *option,
                char *pattern) {
  int filesCount = argc - optind;
  while (optind < argc) {
    FILE *fp = fopen(argv[optind], "r");
    if ((fp == NULL) && !(option->supp_err)) {
      file_open_fail(argv[optind]);
    } else if (fp != NULL) {
      output(argv, fp, option, pattern, filesCount);
      fclose(fp);
    }
    ++optind;
  }
}
