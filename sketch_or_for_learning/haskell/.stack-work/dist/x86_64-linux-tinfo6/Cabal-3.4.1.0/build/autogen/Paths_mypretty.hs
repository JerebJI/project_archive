{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_mypretty (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/jani/Documents/haskell/.stack-work/install/x86_64-linux-tinfo6/5dc8f28c5082044f896244cbdb5e6d05bbc3ea836144834ef6417a7299fb9262/9.0.2/bin"
libdir     = "/home/jani/Documents/haskell/.stack-work/install/x86_64-linux-tinfo6/5dc8f28c5082044f896244cbdb5e6d05bbc3ea836144834ef6417a7299fb9262/9.0.2/lib/x86_64-linux-ghc-9.0.2/mypretty-0.1-Ir3K3UY6K0m961aEieOfWd"
dynlibdir  = "/home/jani/Documents/haskell/.stack-work/install/x86_64-linux-tinfo6/5dc8f28c5082044f896244cbdb5e6d05bbc3ea836144834ef6417a7299fb9262/9.0.2/lib/x86_64-linux-ghc-9.0.2"
datadir    = "/home/jani/Documents/haskell/.stack-work/install/x86_64-linux-tinfo6/5dc8f28c5082044f896244cbdb5e6d05bbc3ea836144834ef6417a7299fb9262/9.0.2/share/x86_64-linux-ghc-9.0.2/mypretty-0.1"
libexecdir = "/home/jani/Documents/haskell/.stack-work/install/x86_64-linux-tinfo6/5dc8f28c5082044f896244cbdb5e6d05bbc3ea836144834ef6417a7299fb9262/9.0.2/libexec/x86_64-linux-ghc-9.0.2/mypretty-0.1"
sysconfdir = "/home/jani/Documents/haskell/.stack-work/install/x86_64-linux-tinfo6/5dc8f28c5082044f896244cbdb5e6d05bbc3ea836144834ef6417a7299fb9262/9.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "mypretty_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "mypretty_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "mypretty_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "mypretty_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "mypretty_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "mypretty_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
