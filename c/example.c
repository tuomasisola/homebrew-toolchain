#include <stdio.h>


int main() {
    char ans[20];
    printf("What is up?\n");
    scanf("%[^\n]s", ans);
    printf("What do you mean by: \"%s\"?\n", ans);
    return 0;
}
