#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
  printf("Starting COW test\n");

  // Allocate one page of memory and write something
  char *p = malloc(4096);
  if (p == 0) {
    printf("malloc failed\n");
    exit(1);
  }
  strcpy(p, "original data");

  int pid = fork();
  if (pid < 0) {
    printf("fork failed\n");
    exit(1);
  }

  if (pid == 0) {
    // Child process
    printf("Child reads: %s\n", p);
    strcpy(p, "child data");  // should trigger COW
    printf("Child writes and reads: %s\n", p);
    exit(0);
  } else {
    // Parent process
    wait(0);
    printf("Parent still reads: %s\n", p);  // should remain unchanged
    free(p);
  }

  printf("COW test finished\n");
  exit(0);
}
