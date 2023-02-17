#include "cat.h"

int main(int argc, char *argv[]) {
  struct cat_options *options;
  options = what_option(argc, argv);
  open_files(argc, argv, *options);
  not_enough_arguments(argc);
  if (options != NULL) {
    free(options);
  }
  return 0;
}

struct cat_options *what_option(int argc, char *argv[]) {
  struct cat_options *options = _init_cat_option();
  int flag;
  const char *short_options = PROGRAM_FLAGS;
  const struct option long_options[] = {
      {"number-nonblank", no_argument, NULL, 'b'},
      {"number", no_argument, NULL, 'n'},
      {"squeeze-blank", no_argument, NULL, 's'},
      {"show-nonprinting", no_argument, NULL, 'v'},
      {"show-ends", no_argument, NULL, 'E'},
      {"show-tabs", no_argument, NULL, 'T'},
      // {"show-all", no_argument, NULL, 'A'}
  };
  while ((flag = getopt_long(argc, argv, short_options, long_options, NULL)) !=
         (-1)) {
    switch (flag) {  // обработка всех опций
      // case 'A':
      //   options.non_print = true;
      //   options.show_ends = true;
      //   options.show_tabs = true;
      //   break;
      case 'b':
        options->number_nonblank_lines = true;
        break;
      case 'e':
        options->show_ends = true;
        options->non_print = true;
        break;
      case 'n':
        options->number_lines = true;
        break;
      case 's':
        options->squeeze_blank = true;
        break;
      case 't':
        options->show_tabs = true;
        options->non_print = true;
        break;
      case 'E':
        options->show_ends = true;
        break;
      case 'v':
        options->non_print = true;
        break;
      case 'T':
        options->show_tabs = true;
        break;
      // case 'u':
      //   break;
      default:
        fprintf(stderr, "usage: %s [-benstvET] [file ...]\n", PROGRAM_NAME);
        exit(EXIT_FAILURE);
    }
  }
  return options;
}

void printNumberLine(int *number) {
  printf("%6d\t", *number);
  *number += 1;
}

void output(FILE *filestream, struct cat_options options) {
  int next = getc(filestream), last = ' ', countEnter = 0, number = 1;
  bool forcontinue = false;
  // next, считываем первый символ. last, обнуляем прошлый символ. countEnter,
  // счетчик энтеров. forcontinptionsременная для обработки для пропуска
  if (options.number_lines && (!options.number_nonblank_lines)) {
    printNumberLine(&number);
  }
  // обработка первой строки при флаге n
  if ((options.number_nonblank_lines) && (next != '\n')) {
    printNumberLine(&number);
  }
  // обработка первой строки при флаге b
  while (!(feof(filestream))) {  // пока не конец файла
    forcontinue = false;  // обнуляем пропуск в начале цикла
    if (next == '\n') {
      countEnter += 1;
    } else {
      countEnter = 0;
    }
    // если энтер увеличиваем счетчик, если нет, то обнуляем
    if ((options.squeeze_blank) && (countEnter > 2)) {
      forcontinue = true;
    }
    // обработка флага s
    if ((options.number_nonblank_lines) && !(countEnter > 1) &&
        (last == '\n') && !(forcontinue)) {
      printNumberLine(&number);
    }  // обработка флага b
    if ((options.number_lines) && (last == '\n') && (!forcontinue) &&
        (!options.number_nonblank_lines)) {
      printNumberLine(&number);
    }
    // обработка флага n, если нет b. флаг b имеет приоритет
    last = next;  // запоминание последнего списаного символа
    if ((next == '\n') && (options.show_ends) && (!forcontinue)) {
      printf("%c%c", '$', next);
      forcontinue = true;
    }
    // обработка флага E
    if ((next == '\t') && (options.show_tabs)) {
      printf("^I");
      forcontinue = true;
    }  // обработка флага T
    if (options.non_print && (!forcontinue)) {  // обработка флага v
      if (next >= 32) {
        if (next < 127) {
          printf("%c", next);
        } else if (next == 127) {
          printf("^?");
        } else {
          printf("M-");
          if (next >= (128 + 32)) {
            if (next < 128 + 127) {
              printf("%c", next - 128);
            } else {
              printf("^?");
            }
          } else {
            printf("^%c", next - 128 + 64);
          }
        }
      } else if ((next == '\t') && (!options.show_tabs)) {
        printf("%c", '\t');
      } else if ((next == '\n') && (!options.show_ends)) {
        printf("\n");
      } else {
        printf("^%c", next + 64);
      }
    } else if ((!options.non_print) &&
               (!forcontinue)) {  // если ничего не подошло
      printf("%c", next);
    }
    next = getc(filestream);  // считывает следующий символ
  }
}

void open_files(int argc, char *argv[], struct cat_options options) {
  FILE *fp;
  int i;
  for (i = optind; i < argc; i++) {
    fp = fopen(argv[i], "rb");
    if (fp == NULL) {  // если файл не открылся
      fprintf(stderr, "%s: %s: No such file or directory\n", PROGRAM_NAME,
              argv[i]);
      continue;
    }
    output(fp, options);
    fclose(fp);
  }
}
