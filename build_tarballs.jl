# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "PCIUtils"
version = v"3.6.2"

# Collection of sources required to build PCIUtils
sources = [
    "https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.6.2.tar.xz" =>
    "db452ec986edefd88af0d222d22f6102f8030a8633fdfe846c3ae4bde9bb93f3",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd pciutils-3.6.2/
make PREFIX=$prefix SHAREDIR=/usr/share/hwdata SHARED=yes -j${nproc}
make PREFIX=$prefix SHAREDIR=/usr/share/hwdata SHARED=yes install install-lib
chmod -v 755 lib/libpci.so.3.6.2 

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "lspci", Symbol("")),
    ExecutableProduct(prefix, "setpci", Symbol("")),
    LibraryProduct(prefix, "libpci", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

