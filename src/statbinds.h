#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>

dev_t get_st_dev(struct stat*s);
ino_t get_st_ino(struct stat*s);
mode_t get_st_mode(struct stat*s);
nlink_t get_st_nlink(struct stat*s);
uid_t get_st_uid(struct stat*s);
gid_t get_st_gid(struct stat*s);
dev_t get_st_rdev(struct stat*s);
off_t get_st_size(struct stat*s);
blksize_t get_st_blksize(struct stat*s);
blkcnt_t get_st_blks(struct stat*s);
time_t get_st_atime(struct stat*s);
time_t get_st_mtime(struct stat*s);
time_t get_st_ctime(struct stat*s);

struct stat* alloc_stat_ptr();
void free_stat_ptr(void* s);

int file_type(mode_t m);

int get_err();
