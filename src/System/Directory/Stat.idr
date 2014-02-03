module System.Directory.Stat

import System.Directory.Providers

%include C "stattypes.h"
%link C "stattypes.o"

%language TypeProviders

%provide (FDevT : FTy) with getDevT
%provide (FInoT : FTy) with getInoT
%provide (FModeT : FTy) with getModeT
%provide (FNLinkT : FTy) with getNlinkT
%provide (FUIDT : FTy) with getUIDT
%provide (FGIDT : FTy) with getGIDT
%provide (FOffT : FTy) with getOffT
%provide (FBlkSizeT : FTy) with BlksizeT
%provide (FBlkCntT : FTy) with getBlkcntT
%provide (FTimeT : FTy) with getTimeT

%include C "statbinds.h"
%link C "statbinds.o"

DevT : Type
DevT = interpFTy FDevT
InoT : Type
InoT = interpFTy FInoT
ModeT : Type
ModeT = interpFTy FModeT
NLinkT : Type
NLinkT = interpFTy FNLinkT
UIDT : Type
UIDT = interpFTy FUIDT
GIDT : Type
GIDT = interpFTy FGIDT
OffT : Type
OffT = interpFTy FOffT
BlkSizeT : Type
BlkSizeT = interpFTy FBlkSizeT
BlkCntT : Type
BlkCntT = interpFTy FBlkCntT
TimeT : Type
TimeT = interpFTy FTimeT

record StructStat : Type where
  MkStat : (st_dev     : DevT) ->
           (st_ino     : InoT) ->
           (st_mode    : ModeT) ->
           (st_nlink   : NLinkT) ->
           (st_uid     : UIDT) ->
           (st_gid     : GIDT) ->
           (st_rdev    : DevT) ->
           (st_size    : OffT) ->
           (st_blksize : BlkSizeT) ->
           (st_blks    : BlkCntT) ->
           (st_atime   : TimeT) ->
           (st_mtime   : TimeT) ->
           (st_ctime   : TimeT) ->
           StructStat


-- actually needs to be a struct stat*, but we can't say that in the type :(
adoptStructStat : Ptr -> IO StructStat
adoptStructStat ptr = do
   [| MkStat !dev !ino !mode !nlink !uid !gid !rdev !size !blksize !blks !atime !mtime !ctime |] ptr
  where
    dev : Ptr -> IO DevT
    dev = mkForeign (FFun "get_st_dev" [FPtr] FDevT)
    ino : Ptr -> InoT
    ino = mkForeign (FFun "get_st_ino" [FPtr] FInoT)
    mode : Ptr -> ModeT
    mode = mkForeign (FFun "get_st_mode" [FPtr] FModeT)
    nlink : Ptr -> NLinkT
    nlink = mkForeign (FFun "get_st_nlink" [FPtr] FNLinkT)
    uid : Ptr -> UIDT
    uid = mkForeign (FFun "get_st_uid" [FPtr] FUIDT)
    gid : Ptr -> GIDT
    gid = mkForeign (FFun "get_st_gid" [FPtr] FGIDT)
    rdev : Ptr -> DevT
    rdev = mkForeign (FFun "get_st_rdev" [FPtr] FDevT)
    size : Ptr -> OffT
    size = mkForeign (FFun "get_st_size" [FPtr] FOffT)
    blksize : Ptr -> BlkSizeT
    blksize = mkForeign (FFun "get_st_blksize" [FPtr] FBlkSizeT)
    blks : Ptr -> BlkCntT
    blks = mkForeign (FFun "get_st_blks" [FPtr] FBlkCntT)
    atime : Ptr -> TimeT
    atime = mkForeign (FFun "get_st_atime" [FPtr] FTimeT)
    mtime : Ptr -> TimeT
    mtime = mkForeign (FFun "get_st_mtime" [FPtr] FTimeT)
    ctime : Ptr -> TimeT
    ctime = mkForeign (FFun "get_st_ctime" [FPtr] FTimeT)

stat : String -> IO StructStat
stat path = do
   ptr <- alloc
   do_stat path ptr
   result <- adoptStructStat ptr
   free ptr
   return result
  where
    alloc : IO Ptr
    alloc = mkForeign (FFun "alloc_stat_ptr" [] FPtr)
    do_stat : String -> Ptr -> IO ()
    do_stat = mkForeign (FFun "stat" [FString, FPtr] FUnit)
    free : Ptr -> IO ()
    free = mkForeign (FFun "free_stat_ptr" [FPtr] FUnit)
   
