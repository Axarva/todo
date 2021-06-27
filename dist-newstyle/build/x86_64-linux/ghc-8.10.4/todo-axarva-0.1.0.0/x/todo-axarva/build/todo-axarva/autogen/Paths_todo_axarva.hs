{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_todo_axarva (
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
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/axarva/.cabal/bin"
libdir     = "/home/axarva/.cabal/lib/x86_64-linux-ghc-8.10.4/todo-axarva-0.1.0.0-inplace-todo-axarva"
dynlibdir  = "/home/axarva/.cabal/lib/x86_64-linux-ghc-8.10.4"
datadir    = "/home/axarva/.cabal/share/x86_64-linux-ghc-8.10.4/todo-axarva-0.1.0.0"
libexecdir = "/home/axarva/.cabal/libexec/x86_64-linux-ghc-8.10.4/todo-axarva-0.1.0.0"
sysconfdir = "/home/axarva/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "todo_axarva_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "todo_axarva_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "todo_axarva_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "todo_axarva_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "todo_axarva_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "todo_axarva_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
