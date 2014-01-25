module System.Directory.Providers

%include C "stattypes.h"
%link C "stattypes.o"

-- The FFI requires knowledge of the sizes of various C types, but gaining
-- access to these is rather involved. We'll define type providers here.
-- We bind to functions defined stattypes.c

getSizeTSizeString : IO String
getSizeTSizeString =
  mkForeign (FFun "sizeof_size_t" [] FString)