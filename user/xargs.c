// #include "kernel/types.h"
// #include "kernel/stat.h"
// #include "kernel/param.h"
// #include "user/user.h"

// // change the standard input to the argvs, using \n to parse the stdio.
// int
// main(int argc, char *argv[])    // the number of argvs can't greater than MAXARG
// {
//     // feed in the data from the stdio of the previous "|"
//     char input[1024];
//     read(0, input, sizeof input);

//     // parse the input
//     parseInput();
//     char *execArg[MAXARG];

//     if (argc == 1) {
//         printf("the size of input is : %d\n", strlen(input));
//         write(1, input, sizeof input);
//         exit(0);
//     }

//     // fill in the exec args of the xarg.
    
//     for(int i = 1; i < argc; i++) {
//         execArg[i - 1] = argv[i];
//     }

//     // the var start means the first index of the execArg that needs to be fed in from the stdio.
//     // int start = argc - 1;

//     // iterate through the input, and fill in the execArg, once it reaches the \n or the end, it will exec the whole execArg.
//     int i = 0;
//     char* argOnce = "";
//     while( i < strlen(input) - 1) {
//         i++ ;
//     }
//     int exeu = fork();
//     if (exeu == 0) {
//         exec("echo", execArg);
//     }
    
    
//     wait(0);
    
//     printf("the first arg : %s\n", input);
//     printf("the execarg 10: %s\n", execArg[0]);
//     exit(0);
// }

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

char *_argv[MAXARG];
char buf[512];
int _argc;

void do_subroutine() {
    int pid = fork();

    if (pid == 0) {
        exec(_argv[0], _argv);
        exit(0);
    }
    wait(0);
}

int main(int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(2, "xargs: too few args\n");
        exit(-1);
    }
    memset(_argv, 0, sizeof(_argv));
    _argc = argc - 1;
    for (int i = 1; i < argc; i++) {
        _argv[i - 1] = argv[i];
    }

    struct stat st;

    if(fstat(0, &st) < 0) {
        int pos = 0;
        
        _argv[_argc] = buf;

        memset(buf, 0, sizeof(buf));

        while(read(0, &buf[pos], 1) > 0) {
            if (buf[pos] == '\n') {
                buf[pos] = 0;

                do_subroutine();

                pos = 0;
                memset(buf, 0, sizeof(buf));
            } else {
                pos++;
            }
        }
        if (buf[0]) {
            do_subroutine();
        }
    } else {
        do_subroutine();
    }

    exit(0);
}