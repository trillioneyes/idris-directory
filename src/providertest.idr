module Main
import System.Directory.Providers

main : IO ()
main = getSizeTSize >>= putStrLn . show