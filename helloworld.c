#include <stdio.h>

char *getlogin();

int main(int argc, char *argv[]) {

  printf("Hello %s", getlogin());

  return 0;
}
