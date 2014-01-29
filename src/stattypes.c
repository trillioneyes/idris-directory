#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>

#include "stattypes.h"

// return the sizes of various member types of struct stat for use in
// type providers

// To find the size of size_t we cannot use size_t, so we will use a string.
// This is terrible.
char* size_to_string(size_t size) {
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
// And finally, we need to have two references to the string: one as an FString
// (which will be copied and used) and one as a Ptr (which will be passed to
// free_string()). Since Idris copies FStrings when it retrieves Strings from
// them, we can simply use an identity function on the pointer.
char* kind_of_copy(char* ptr) { return ptr; }

// now that we've gotten the string out of the way, hopefully we can understand
// size_t
char* sizeof_dev_t() { return size_to_string(sizeof(dev_t)); }
char* sizeof_ino_t() { return size_to_string(sizeof(ino_t)); }
char* sizeof_mode_t() { return size_to_string(sizeof(mode_t)); }
char* sizeof_nlink_t() { return size_to_string(sizeof(nlink_t)); }
char* sizeof_uid_t() { return size_to_string(sizeof(uid_t)); }
char* sizeof_gid_t() { return size_to_string(sizeof(gid_t)); }
char* sizeof_off_t() { return size_to_string(sizeof(off_t)); }
char* sizeof_blksize_t() { return size_to_string(sizeof(blksize_t)); }
char* sizeof_blkcnt_t() { return size_to_string(sizeof(blkcnt_t)); }
char* sizeof_time_t() { return size_to_string(sizeof(time_t)); }



/*
int main(int argc, char** argv) {
  char* buf = sizeof_size_t();
  printf("Reported size of size_t: %s",buf);
  printf("\nActual size of size_t: %d\n", (int)sizeof(size_t));
  free(buf);
  return 0;
}
*/
