#include "kernel/types.h"
#include "user/user.h"

#define PGSIZE 4096

void cowtest() {
    int *shared = (int*)sbrk(PGSIZE); // Allocate one page
    *shared = 42; // Initialize value

    printf("Parent set shared value to: %d\n", *shared);

    int pid = fork();
    if (pid < 0) {
        printf("Fork failed\n");
        exit(1);
    } else if (pid == 0) {
        // Child process
        printf("Child reads shared value: %d\n", *shared);
        *shared = 100; // Modify the value (should trigger COW)
        printf("Child changed value to: %d\n", *shared);
        exit(0);
    } else {
        // Parent process
        wait(0); // Wait for child
        printf("Parent checks value after child modified: %d (should still be 42)\n", *shared);
        
        if (*shared == 42) {
            printf("COW test PASSED!\n");
        } else {
            printf("COW test FAILED!\n");
        }
        
        sbrk(-PGSIZE); // Free the page
    }
}

int main(int argc, char *argv[]) {
    cowtest();
    exit(0);
}
