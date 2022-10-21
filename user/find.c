#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void
find(char *path, char *file)
{
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    // check the path
    if((fd = open(path, 0)) < 0){
        fprintf(2, "find: cannot open the dir: %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "find : cannot stat the dir: %s\n", path);
        close(fd);
        return;
    }

    if(st.type != T_DIR) {
        fprintf(2, "find : the first arg should be dir: %s\n", path);
        close(fd);
        return;
    }

    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
        printf("ls: path too long\n");
        close(fd);
        return;
    }

    // copy the path to the buf and move the p to the end of the buf
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';

    // iterate through all the file within the path
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.inum == 0)
            continue;
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;
        if(stat(buf, &st) < 0){
            printf("ls: cannot stat %s\n", buf);
            continue;
        }
        if (strcmp(file, de.name) == 0) {
            printf("%s\n", buf);
        }
        // do not recurse into . and .. since it will result in endless loop
        if (st.type == T_DIR && strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0) {
            find(buf, file);
        } 
    }
    close(fd);
}

int
main(int argc, char *argv[])
{
    if(argc != 3){
        fprintf(2, "Usage: find files...\n");
        exit(1);
    }

    find(argv[1], argv[2]);
    exit(0);
}