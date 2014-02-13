#include "stdlib.h"
#include "sys/stat.h"
#include "dirent.h"
#include "stdio.h"

// accessors
dev_t get_st_dev(struct stat*s) {return s->st_dev;}
ino_t get_st_ino(struct stat*s) {return s->st_ino;}
mode_t get_st_mode(struct stat*s) {return s->st_mode;}
nlink_t get_st_nlink(struct stat*s) {return s->st_nlink;}
uid_t get_st_uid(struct stat*s) {return s->st_uid;}
gid_t get_st_gid(struct stat*s) {return s->st_gid;}
dev_t get_st_rdev(struct stat*s) {return s->st_rdev;}
off_t get_st_size(struct stat*s) {return s->st_size;}
blksize_t get_st_blksize(struct stat*s) {return s->st_blksize;}
blkcnt_t get_st_blks(struct stat*s) {return s->st_blocks;}
time_t get_st_atime(struct stat*s) {return s->st_atime;}
time_t get_st_mtime(struct stat*s) {return s->st_mtime;}
time_t get_st_ctime(struct stat*s) {return s->st_ctime;}

// Idris will call these functions before and after constructing a StructStat
struct stat* alloc_stat_ptr() {
  return (void*)malloc(sizeof(struct stat));
}
void free_stat_ptr(void* s) {
  free((struct stat*)s);
}

// Return a code for the file type instead of just extracting the relevant
// bits because I'm paranoid
// idris will then pattern match on the integer and we'll leave the whole
// travesty behind us
int file_type(mode_t m) {
  if (S_ISREG(m)) return 0;
  if (S_ISDIR(m)) return 1;
  if (S_ISCHR(m)) return 2;
  if (S_ISBLK(m)) return 3;
  if (S_ISFIFO(m)) return 4;
  if (S_ISLNK(m)) return 5;
  if (S_ISSOCK(m)) return 6;
  return 7;
}

/*
int main(int argc, char** argv) {
  DIR* home = opendir(argv[1]);
  if (!home) return 1;
  struct stat s;
  for (struct dirent* e = readdir(home); e; e = readdir(home)) {
    stat(e->d_name, &s);
    if (S_ISREG(s.st_mode)) {
      printf("%s: file\n", e->d_name);
    }
    else if (S_ISDIR(s.st_mode)){
      printf("was not a file; checking for directory\n");
      printf("%s: directory\n", e->d_name);
    }
    else printf("%s: I have no idea what this alien file is\n", e->d_name);
  }
  closedir(home);
  return 0;
}
*/
