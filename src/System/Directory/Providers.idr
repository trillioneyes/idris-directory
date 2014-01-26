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

getSizeTSizeString : IO Int
getSizeTSizeString = do
   ptr <- getPtr
   str <- copy ptr
   free ptr
   return (readInt str)
  where
    getPtr : IO Ptr
    getPtr = mkForeign (FFun "sizeof_size_t" [] FPtr)
    copy : Ptr -> IO String
    copy p = mkForeign (FFun "kind_of_copy" [FPtr] FString) p
    free : Ptr -> IO ()
    free p = mkForeign (FFun "free_string" [FPtr] FUnit) p