module Main
import System.Directory.Providers

-- debugging is intolerable without this
instance Show IntTy where
  show ITChar = "Char"
  show ITNative = "Int"
  show IT8 = "8bits"
  show IT16 = "16bits"
  show IT32 = "32bits"
  show IT64 = "64bits"
  show _ = "vector"

main : IO ()
main = do
  putStrLn "Beginning test..."
  FIntT dev_t <- getDevT
  putStrLn $ "dev_t is " ++ show dev_t