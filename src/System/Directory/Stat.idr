module System.Directory.Stat

import System.Directory.Providers

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