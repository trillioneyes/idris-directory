module System.Directory.Providers

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
   putStrLn "Producing pointer..."
   ptr <- getPtr
   putStrLn "Pointer produced; copying string..."
   str <- copy ptr
   putStrLn ("Copied " ++ show str ++ "; freeing pointer")
   free ptr
   putStrLn "Freed pointer."
   return (readInt str)
  where
    copy : Ptr -> IO String
    copy p = mkForeign (FFun "kind_of_copy" [FPtr] FString) p
    free : Ptr -> IO ()
    free p = mkForeign (FFun "free_string" [FPtr] FUnit) p

bytesToType : Int -> FTy
bytesToType 1 = FIntT IT8
bytesToType 2 = FIntT IT16
bytesToType 4 = FIntT IT32
bytesToType 8 = FIntT IT64


-- use the given foreign function and size_t to look up a C type
useForeign : IO Ptr -> IO FTy
useForeign getPtr = map bytesToType (getSize getPtr)

getDevT : IO FTy
getDevT = useForeign (mkForeign (FFun "sizeof_dev_t" [] FPtr))

getInoT : IO FTy
getInoT = useForeign (mkForeign (FFun "sizeof_ino_t" [] FPtr ))

getModeT : IO FTy
getModeT = useForeign (mkForeign (FFun "sizeof_ino_t" [] FPtr ))

getNlinkT : IO FTy
getNlinkT = useForeign (mkForeign (FFun "sizeof_nlink_t" [] FPtr ))

getUIDT : IO FTy
getUIDT = useForeign (mkForeign (FFun "sizeof_uid_t" [] FPtr ))

getGIDT : IO FTy
getGIDT = useForeign (mkForeign (FFun "sizeof_gid_t" [] FPtr ))

getOffT : IO FTy
getOffT = useForeign (mkForeign (FFun "sizeof_off_t" [] FPtr ))

getBlksizeT : IO FTy
getBlksizeT = useForeign (mkForeign (FFun "sizeof_blksize_t" [] FPtr ))

getBlkcntT : IO FTy
getBlkcntT = useForeign (mkForeign (FFun "sizeof_blkcnt_t" [] FPtr ))

getTimeT : IO FTy
getTimeT = useForeign (mkForeign (FFun "sizeof_time_t" [] FPtr ))