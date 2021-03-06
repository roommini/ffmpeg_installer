#!/usr/bin/env bash

# A Linux Shell Script for compiling and installing ffmpeg in CentOS (tested on 7).
# This script based on ffmpeg guide <https://trac.ffmpeg.org/wiki/CompilationGuide/Centos>
# This script is licensed under GNU GPL version 3.0 or above.


# Remove any existing packages
yum -y erase ffmpeg x264 x264-devel

#Setup EPEL Repository
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum update -y
yum groupinstall "Development Tools" -y

yum -y install yum-utils
yum -y install freetype-devel

# Install the dependencies
yum -y install autoconf automake bzip2 cmake gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel

# Make a directory for FFmpeg sources
mkdir ~/ffmpeg_sources

# Install NASM
cd ~/ffmpeg_sources
curl -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
tar xjvf nasm-2.14.02.tar.bz2
cd nasm-2.14.02
./autogen.sh
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean
source ~/.bash_profile

# Install Yasm
cd ~/ffmpeg_sources
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean
source ~/.bash_profile

# Install x264
cd ~/ffmpeg_sources
curl -O https://code.videolan.org/videolan/x264/-/archive/stable/x264-stable.tar.gz
tar xzvf x264-stable.tar.gz
cd x264-stable
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
make distclean
source ~/.bash_profile

# Install libfdk_aac
cd ~/ffmpeg_sources
git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
source ~/.bash_profile

# Install libmp3lame
cd ~/ffmpeg_sources
curl -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make
make install
make distclean
source ~/.bash_profile

# Install libopus
cd ~/ffmpeg_sources
curl -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
tar xzvf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
source ~/.bash_profile

# Install libogg
#cd ~/ffmpeg_sources
#curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
#tar xzvf libogg-1.3.2.tar.gz
#cd libogg-1.3.2
#./configure --prefix="$HOME/ffmpeg_build" --disable-shared
#make
#make install
#make distclean
#source ~/.bash_profile
#yum -y install libogg

# Install libvorbis
#cd ~/ffmpeg_sources
#curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
#tar xzvf libvorbis-1.3.4.tar.gz
#cd libvorbis-1.3.4
#./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
#make
#make install
#make distclean
#source ~/.bash_profile
#yum -y install libvorbis

# Install libtheora
# cd ~/ffmpeg_sources
# wget http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
# tar xzvf libtheora-1.1.1.tar.gz
# cd libtheora-1.1.1
# ./configure --disable-shared
# make
# make install
# make distclean
# source ~/.bash_profile
#yum -y install libtheora

# Install libvpx
cd ~/ffmpeg_sources
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --disable-examples  --as=yasm
PATH="$HOME/bin:$PATH" make
make install
make distclean
source ~/.bash_profile
yum -y install libvpx

# Install FFmpeg
cd ~/ffmpeg_sources
curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree
make
make install
hash -r

make distclean
source ~/.bash_profile
