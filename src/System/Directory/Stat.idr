module System.Directory.Stat

import System.Directory.Providers

--%include C "stattypes.h"
--%link C "stattypes.o"
%include C "statbinds.h"
%link C "statbinds.o"
%dynamic "./stattypes.so"
%dynamic "./statbinds.so"


%language TypeProviders

%provide (FDevT : FTy) with getDevT
%provide (FInoT : FTy) with getInoT
%provide (FModeT : FTy) with getModeT
%provide (FNLinkT : FTy) with getNlinkT
%provide (FUIDT : FTy) with getUIDT
%provide (FGIDT : FTy) with getGIDT
%provide (FOffT : FTy) with getOffT
%provide (FBlkSizeT : FTy) with getBlksizeT
%provide (FBlkCntT : FTy) with getBlkcntT
%provide (FTimeT : FTy) with getTimeT

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
   dev <- dev' ptr
   ino <- ino' ptr
   mode <- mode' ptr
   nlink <- nlink' ptr
   uid <- uid' ptr
   gid <- gid' ptr
   rdev <- rdev' ptr
   size <- size' ptr
   blksize <- blksize' ptr
   blks <- blks' ptr
   atime <- atime' ptr
   mtime <- mtime' ptr
   ctime <- ctime' ptr
   return $ MkStat dev ino mode nlink uid gid rdev size blksize blks atime mtime ctime
  where
    dev' : Ptr -> IO DevT
    dev' ptr = mkForeign (FFun "get_st_dev" [FPtr] FDevT) ptr
    ino' : Ptr -> IO InoT
    ino' ptr = mkForeign (FFun "get_st_ino" [FPtr] FInoT) ptr
    mode' : Ptr -> IO ModeT
    mode' ptr = mkForeign (FFun "get_st_mode" [FPtr] FModeT) ptr
    nlink' : Ptr -> IO NLinkT
    nlink' ptr = mkForeign (FFun "get_st_nlink" [FPtr] FNLinkT) ptr
    uid' : Ptr -> IO UIDT
    uid' ptr = mkForeign (FFun "get_st_uid" [FPtr] FUIDT) ptr
    gid' : Ptr -> IO GIDT
    gid' ptr = mkForeign (FFun "get_st_gid" [FPtr] FGIDT) ptr
    rdev' : Ptr -> IO DevT
    rdev' ptr = mkForeign (FFun "get_st_rdev" [FPtr] FDevT) ptr
    size' : Ptr -> IO OffT
    size' ptr = mkForeign (FFun "get_st_size" [FPtr] FOffT) ptr
    blksize' : Ptr -> IO BlkSizeT
    blksize' ptr = mkForeign (FFun "get_st_blksize" [FPtr] FBlkSizeT) ptr
    blks' : Ptr -> IO BlkCntT
    blks' ptr = mkForeign (FFun "get_st_blks" [FPtr] FBlkCntT) ptr
    atime' : Ptr -> IO TimeT
    atime' ptr = mkForeign (FFun "get_st_atime" [FPtr] FTimeT) ptr
    mtime' : Ptr -> IO TimeT
    mtime' ptr = mkForeign (FFun "get_st_mtime" [FPtr] FTimeT) ptr
    ctime' : Ptr -> IO TimeT
    ctime' ptr = mkForeign (FFun "get_st_ctime" [FPtr] FTimeT) ptr

-- the int is just the C errno
stat : String -> IO (Either Int StructStat)
stat path = do
   ptr <- alloc
   err <- do_stat path ptr
   if err /= (-1)
     then do
       result <- adoptStructStat ptr
       free ptr
       return (Right result)
     else map Left getError     
  where
    alloc : IO Ptr
    alloc = mkForeign (FFun "alloc_stat_ptr" [] FPtr)
    do_stat : String -> Ptr -> IO Int
    do_stat name ptr = mkForeign (FFun "stat" [FString, FPtr] FInt) name ptr
    free : Ptr -> IO ()
    free ptr = mkForeign (FFun "free_stat_ptr" [FPtr] FUnit) ptr
    getError : IO Int
    getError = mkForeign (FFun "get_err" [] FInt)
   


-- Next, a nicer interface to StructStat
data FileType = Regular | Directory | CharDev | BlockDev | FIFO | SymLink | Socket

instance Show FileType where
  show Regular = "Regular"
  show Directory = "Directory"
  show CharDev = "CharDev"
  show BlockDev = "BlockDev"
  show FIFO = "FIFO"
  show SymLink = "SymLink"
  show Socket = "Socket"

modeToType : ModeT -> Maybe FileType
modeToType x = interp (typeCode x) where
  typeCode : ModeT -> Int
  -- this is safe because it's just bit twiddling
  typeCode x = unsafePerformIO $ mkForeign (FFun "file_type" [FModeT] FInt) x
  interp : Int -> Maybe FileType
  interp 0 = Just Regular
  interp 1 = Just Directory
  interp 2 = Just CharDev
  interp 3 = Just BlockDev
  interp 4 = Just FIFO
  interp 5 = Just SymLink
  interp 6 = Just Socket
  interp _ = Nothing
