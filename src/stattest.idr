module Main
import System.Directory.Stat
import System

main : IO ()
main = do
  [_,name] <- getArgs
  info <- stat name
  putStr "Number of links: "
  putStr $ show (st_nlink info)
  putStr "; last accessed at: "
  putStrLn $ show (st_atime info)
