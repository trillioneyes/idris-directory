#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>

// return the sizes of various member types of struct stat for use in
// type providers

// To find the size of size_t we cannot use size_t, so we will use a string.
// This is terrible.
char* sizeof_size_t() {
  size_t size = sizeof(size_t);
  // calculate the buffer size
  unsigned int bsize = 0;
  for (unsigned int i = size; i > 0; i = i/10) {
    bsize++;
  }
  char *buf = malloc((bsize+1) * sizeof(char));
  if (!buf) return NULL;
  // this coerces `size` to an int, which will probably work in most cases
  // but not in all. Probably better to calculate the digits manually?
  sprintf(buf,"%d",(int)size);
  return buf;
}
// Idris also must be able to free the above abomination after reading it
void free_string(char* ptr) {
  free(ptr);
}

// now that we've gotten the string out of the way, hopefully we can understand
// size_t
size_t sizeof_dev_t() { return sizeof(dev_t); }
size_t sizeof_ino_t() { return sizeof(ino_t); }
size_t sizeof_mode_t() { return sizeof(mode_t); }
size_t sizeof_nlink_t() { return sizeof(nlink_t); }
size_t sizeof_uid_t() { return sizeof(uid_t); }
size_t sizeof_gid_t() { return sizeof(gid_t); }
size_t sizeof_off_t() { return sizeof(off_t); }
size_t sizeof_blksize_t() { return sizeof(blksize_t); }
size_t sizeof_blkcnt_t() { return sizeof(blkcnt_t); }
size_t sizeof_time_t() { return sizeof(time_t); }



/*
int main(int argc, char** argv) {
  char* buf = sizeof_size_t();
  printf("Reported size of size_t: %s",buf);
  printf("\nActual size of size_t: %d\n", (int)sizeof(size_t));
  free(buf);
  return 0;
}
*/
