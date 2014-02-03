module System.Directory.Providers

import Providers
%link C "stattypes.o"
%include C "stattypes.h"

readInt : String -> Int
readInt = readFromList . unpack
  where digit : Char -> Int
        digit x = ord x - ord '0'
        read : Int -> List Char -> Int
        read acc (x::xs) = read (acc*10 + digit x) xs
        read acc [] = acc
        readFromList : List Char -> Int
        readFromList = read 0
        

-- The FFI requires knowledge of the sizes of various C types, but gaining
-- access to these is rather involved. We'll define type providers here.
-- We bind to functions defined in stattypes.c

getSize : IO Ptr -> IO Int
getSize getPtr = do
   ptr <- getPtr
   str <- copy ptr
   free ptr
   return (readInt str)
  where
    copy : Ptr -> IO String
    copy p = mkForeign (FFun "kind_of_copy" [FPtr] FString) p
    free : Ptr -> IO ()
    free p = mkForeign (FFun "free_string" [FPtr] FUnit) p

bytesToType : Int -> Provider FTy
bytesToType 1 = Provide $ FIntT IT8
bytesToType 2 = Provide $ FIntT IT16
bytesToType 4 = Provide $ FIntT IT32
bytesToType 8 = Provide $ FIntT IT64
bytesToType _ = Error "Size does not correspond to any integer type"


-- use the given foreign function and size_t to look up a C type
useForeign : IO Ptr -> IO (Provider FTy)
useForeign getPtr = map bytesToType (getSize getPtr)

getDevT : IO (Provider FTy)
getDevT = useForeign (mkForeign (FFun "sizeof_dev_t" [] FPtr))

getInoT : IO (Provider FTy)
getInoT = useForeign (mkForeign (FFun "sizeof_ino_t" [] FPtr))

getModeT : IO (Provider FTy)
getModeT = useForeign (mkForeign (FFun "sizeof_ino_t" [] FPtr))

getNlinkT : IO (Provider FTy)
getNlinkT = useForeign (mkForeign (FFun "sizeof_nlink_t" [] FPtr))

getUIDT : IO (Provider FTy)
getUIDT = useForeign (mkForeign (FFun "sizeof_uid_t" [] FPtr))

getGIDT : IO (Provider FTy)
getGIDT = useForeign (mkForeign (FFun "sizeof_gid_t" [] FPtr))

getOffT : IO (Provider FTy)
getOffT = useForeign (mkForeign (FFun "sizeof_off_t" [] FPtr))

getBlksizeT : IO (Provider FTy)
getBlksizeT = useForeign (mkForeign (FFun "sizeof_blksize_t" [] FPtr))

getBlkcntT : IO (Provider FTy)
getBlkcntT = useForeign (mkForeign (FFun "sizeof_blkcnt_t" [] FPtr))

getTimeT : IO (Provider FTy)
getTimeT = useForeign (mkForeign (FFun "sizeof_time_t" [] FPtr))
