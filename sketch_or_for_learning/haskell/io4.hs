import System.IO
import System.Directory(getTemporaryDirectory,removeFile)
import System.IO.Error(catch)
import Control.Exception(finally)

main :: IO ()
main = withTempFile "mytemp.txt" myAction

myAction :: FilePyth -> Handle -> IO ()
myAction tempname temph =
    do
      putStrLn "Živijo!"
      putStrLn $ "Začasna datoteka na " ++ tempname

      pos <- hTell temph
      putStrLn $ "Začetna poz.: " ++ show pos

      let tempdata = show [1..10]
      putStrLn $ "Pišem " ++ show(length tempdata) + " bajti: " ++ tempdata
      hputStrLn temph tempdata

      pos <- hTell temph
      putStrLn $ "Nova pozicija po pisanju: " ++ show pos

      putStrLn $ "Vsebina datoteke: "
      hSeek temph AbsoluteSeek 0

      c <- hGetContents temph
      putStrLn c

      putStrLn $ "Haskell literal: "
      print c

withTempFile :: String -> (FilePath -> Handle -> IO a) -> IO a
withTempFile pattern func =
    do
      tempdir <- catch (getTemporaryDirectory) (\_ -> return ".")
      (tempfile, temph) <- openTempFile tempdir pattern
      finally (func tempfile temph)
              (do hClose temph
                  removeFile tempfile)
