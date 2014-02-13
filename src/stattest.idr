module Main
import System.Directory.Stat
import System

(>>) : Monad m => m a -> m b -> m b
a >> b = a >>= (const b)

describe : StructStat -> (name:String) -> String
describe s name =
  name ++ " is a " ++ maybe "monster" show (modeToType (st_mode s))

linksTime : StructStat -> (name:String) -> String
linksTime s name =
  "Number of links: " ++ show (st_nlink s) ++ "; last accessed at: " ++ show (st_atime s)

report : (name:String) -> StructStat -> IO ()
report name s = putStrLn (describe s name) >> putStrLn (linksTime s name)

reportError : Int -> IO ()
reportError errno = putStrLn $ "Received an unknown error. Code: " ++ show errno

main : IO ()
main = do
  case !getArgs of
    [_,name] => do
      info <- stat name
      either reportError (report name) info
    _ => putStrLn "Usage: ./stattest <file-or-directory>"
