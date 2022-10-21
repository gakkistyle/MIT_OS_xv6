#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    int pid, n;
    int fds[2], fds2[2];
    char buf[100];

    // create a pipe, with two FDs in fds[0], fds[1];
    pipe(fds);
    pipe(fds2);
    char byte[] = "a";

    pid = fork();

    if(pid == 0) {
        n = read(fds[0], buf, sizeof(buf));
        if (n > 0) {
            printf("%d: received ping\n", getpid());
            write(fds2[1], buf, n);
            exit(0);
        }
        fprintf(2, "%d: received ping error!\n", getpid());
        exit(1);
    } else {
        write(fds[1], byte, sizeof(byte));
        n = read(fds2[0], buf, sizeof(buf));
        if (n > 0) {
            printf("%d: received pong\n", getpid());
            exit(0);
        }
        fprintf(2, "%d: received pong error!\n", getpid());
        exit(1);
    }
    close(fds[0]);
    close(fds[1]);
    close(fds2[0]);
    close(fds2[1]);
    exit(0);
}