#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void PipeLine(int fds[])
{
    int out, nextOut;

    int fdsNext[2] = {-1};   // a very important procedure that assign -1 to the first entry. Otherwise the output sequence can be out of order.
    close(fds[1]);
    if (read(fds[0], &out, sizeof(out)) > 0) {
        printf("prime %d\n", out);

        while (read(fds[0], &nextOut, sizeof(nextOut)) > 0) {
            if (nextOut % out != 0) {
                if (fdsNext[0] < 0) {
                    pipe(fdsNext);        // only pipe when needed.

                    int pid = fork();
                    if (pid == 0) {
                        PipeLine(fdsNext);
                        exit(0);
                    }
                }
                write(fdsNext[1], &nextOut, sizeof(nextOut));
            }
        }
        close(fdsNext[1]);   //the close func before the wait syscall is essential, not close can result in the lack of fd.
        wait(0);
        close(fdsNext[1]);   //the close func after the wait syscall is not neccessary to get things right.
        close(fdsNext[0]);
    }
    exit(0);
}

int
main(int argc, char *argv[])
{
    if(argc > 1) {
        fprintf(2, "primes should not have arguments\n");
        exit(1);
    }

    int fds[2];
    pipe(fds);

    int pid = fork();

    if (pid == 0) {
        PipeLine(fds);
    } else {
        for (int i = 2; i <= 35; i++) {
            write(fds[1], &i, sizeof(i));
        }
        close(fds[1]);
        wait(0);
        close(fds[0]);
    }
    
    exit(0);
}