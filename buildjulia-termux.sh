#!/data/data/com.termux/files/usr/bin/sh
export LD_LIBRARY_PATH=$PWD/usr/lib:$LD_LIBRARY_PATH
cp Make.user-termux Make.user
export LDFLAGS="-L$PWD/usr/lib -L$PREFIX/lib -lm -lcompiler_rt -landroid-support -lopenblas -lbthread  -lgfortran -latomic"
echo "JULIA for android..."
echo "THIS NEEDS suitesparse-dev libgfortran4 openblas arpack-ng libssh2-dev libcurl-dev patchelf libgmp-dev pcre2-dev"
echo "arm and aarch64 need gcc-7"
echo " arm also needs libunwind-dev"
TERMUX_ARCH=$(dpkg --print-architecture)
# for arm compiling src/support/hashing.c with clang creates bus errors so need to use gcc-7

if [ $TERMUX_ARCH = "arm" ]; then
echo "USE_SYSTEM_LIBUNWIND:=1" >> Make.user
echo "DISABLE_LIBUNWIND:=0" >> Make.user

gcc-7 -fasynchronous-unwind-tables -DSYSTEM_LLVM -DJULIA_ENABLE_THREADING -DJULIA_NUM_THREADS=3 -DJL_DISABLE_LIBUNWIND -std=gnu99 -pipe -fPIC -fno-strict-aliasing -D_FILE_OFFSET_BITS=64 -fsigned-char -Wold-style-definition -Wstrict-prototypes -Wc++-compat -O3 -ggdb2 -falign-functions  -I$PWD/usr/include -DLIBRARY_EXPORTS -DUTF8PROC_EXPORTS -Wall -Wno-strict-aliasing -fvisibility=hidden -Wpointer-arith -Wundef -DNDEBUG -DJL_NDEBUG -c src/support/hashing.c -o src/support/hashing.o


elif [ $TERMUX_ARCH = "aarch64" ]; then
# compiling fails using clang for these files so use gcc-7 
gcc-7 -fasynchronous-unwind-tables -DSYSTEM_LLVM -DJULIA_HAS_IFUNC_SUPPORT=1 -DJULIA_ENABLE_THREADING -DJULIA_NUM_THREADS=3 -DJL_DISABLE_LIBUNWIND -std=gnu99 -pipe -fPIC -fno-strict-aliasing -D_FILE_OFFSET_BITS=64 -Wold-style-definition -Wstrict-prototypes -Wc++-compat -O3 -ggdb2 -falign-functions -D_GNU_SOURCE -I. -I$PWD/src -I$PWD/src/flisp -I$PWD/src/support -I$PWD/usr/include -DLIBRARY_EXPORTS -I$PWD/deps/valgrind -Wall -Wno-strict-aliasing -fno-omit-frame-pointer -fvisibility=hidden -fno-common -Wpointer-arith -Wundef -DJL_BUILD_ARCH='"aarch64"' -DJL_BUILD_UNAME='"Linux"' -I/data/data/com.termux/files/usr/include -DLLVM_SHLIB "-DJL_SYSTEM_IMAGE_PATH=\"../lib/julia/sys.so\"" -DNDEBUG -DJL_NDEBUG  -c src/task.c -o src/task.o
gcc-7 -fasynchronous-unwind-tables -DSYSTEM_LLVM -DJULIA_HAS_IFUNC_SUPPORT=1 -DJULIA_ENABLE_THREADING -DJULIA_NUM_THREADS=3 -DJL_DISABLE_LIBUNWIND -std=gnu99 -pipe -fPIC -fno-strict-aliasing -D_FILE_OFFSET_BITS=64 -Wold-style-definition -Wstrict-prototypes -Wc++-compat -O3 -ggdb2 -falign-functions -D_GNU_SOURCE -I. -I$PWD/src -I$PWD/src/flisp -I$PWD/src/support -I$PWD/usr/include -DLIBRARY_EXPORTS -I$PWD/deps/valgrind -Wall -Wno-strict-aliasing -fno-omit-frame-pointer -fvisibility=hidden -fno-common -Wpointer-arith -Wundef -DJL_BUILD_ARCH='"aarch64"' -DJL_BUILD_UNAME='"Linux"' -I/data/data/com.termux/files/usr/include -DLLVM_SHLIB "-DJL_SYSTEM_IMAGE_PATH=\"../lib/julia/sys.so\"" -DNDEBUG -DJL_NDEBUG  -c src/crc32c.c -o src/crc32c.o
fi
make termux
