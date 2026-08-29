#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <sysexits.h>
#include <unistd.h>




char *take_input(char *buff, size_t buff_size) {
    printf("> ");
    return fgets(buff, buff_size, stdin);
}


int main(int argc, char *argv[]) {

    (void)argc;
    (void)argv;
    
    char buff[BUFSIZ];

    while(take_input(buff, sizeof(buff))) {
        buff[strlen(buff) - 1]= '\0';

        int pid = 0;
        if( (pid = fork()) < 0) {
            fprintf(stderr, "shell: fork failed %s\n", strerror(errno));

            continue;
        } else if(pid == 0){
            // in child process

            execlp(buff, buff, (char *)0);
            fprintf(stderr, "could not exec %s %s", buff, strerror(errno));
            exit(EX_UNAVAILABLE);
        }

        int status;

        if((pid=waitpid(pid, &status, 0)) < 0) {
            fprintf(stderr, "shell: wait pid error %s\n", strerror(errno));
            exit(EXIT_FAILURE);
        }
    }
    exit(EXIT_SUCCESS);
}
