#include <stdio.h>

char *getlogin();

int main(int argc, char *argv[]) {

  (void)argc;
  (void)argv;
  printf("Hello %s\n", getlogin());

  return 0;
}
