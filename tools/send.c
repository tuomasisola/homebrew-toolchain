/* Commandline helper to include delay between chars
when sending hex file to the serial interface */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
    double time;
    int c;

    if (argc == 2) {
        time = atof(argv[1]); // argv[1] is in seconds
    } else {
        fprintf(stderr, "(Only) one argument expected.\n");
        return 0;
    }

    while ((c = getchar()) != EOF) {
        usleep(time * 100000);
        putchar(c);
        fflush(stdout);
    }
    return 0;
}
