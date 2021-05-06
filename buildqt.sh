#!/bin/bash

sudo apt update
# sudo apt upgrade -y
# sudo apt dist-upgrade -y
sudo apt install -y wget xz-utils
sudo apt install -y openjdk-8-jdk openjdk-8-jdk-headless
# sudo apt install -y android-sdk
sudo apt autoremove -y
sudo apt autoclean -y

# libfontconfig1-dev \
# libfreetype6-dev \
# libx11-dev \
# libx11-xcb-dev \
# libxext-dev \
# libxfixes-dev \
# libxi-dev \
# libxrender-dev \
# libxcb1-dev \
# libxcb-glx0-dev \
# libxcb-keysyms1-dev \
# libxcb-image0-dev \
# libxcb-shm0-dev \
# libxcb-icccm4-dev \
# libxcb-sync0-dev \
# libxcb-xfixes0-dev \
# libxcb-shape0-dev \
# libxcb-randr0-dev \
# libxcb-render-util0-dev \
# libxcb-xinerama0-dev \
# libxkbcommon-dev \
# libxkbcommon-x11-dev \
# libclang-dev \
# freeglut3-dev \
# mesa-utils \
# libdrm-dev \
# libgles2-mesa-dev \
# binutils \
# g++ \
# cmake \
# g++ \
# mesa-common-dev \
# build-essential \
# libglew-dev \
# libglm-dev \
# make \
# gcc \
# pkg-config \
# libgl1-mesa-dev \
# libxcb1-dev \
# libfontconfig1-dev \
# libxkbcommon-x11-dev \
# python \
# libgtk-3-dev \
# build-essential \
# default-jre \
# android-sdk \
# android-sdk-platform-23 \
# libc6-i386 \
# libdrm-dev \
# libgles2-mesa-dev \
# libzc-dev \
# libxcb-sync-dev \
# libsmartcols-dev \
# libicecc-dev \
# libpthread-workqueue-dev \
# libgstreamer1.0-dev \
# libgcrypt20-dev \
# libqt5gui5-gles \
# qca-qt5-2-utils \
# xorg \
# xorg-dev

QT_VERSION_MAJOR=5.15
QT_VERSION=5.15.2
QTROOTFOLDER=$HOME/Qt

if [ -z "${ANDROID_SDK_ROOT}" ];  then

    export ANDROID_SDK_XROOT=$HOME/android-sdk
    
    export ANDROID_SDK_PLATFORM_VER=android-30
    export ANDROID_SDK_BUILDTOOLS_VER=30.0.2
    export ANDROID_SDK_SOURCESDK_VER=commandlinetools-linux-6200805_latest.zip
    
    #export ANDROID_NDK_XNAME=android-ndk-r21b-linux-x86_64.zip
    #export ANDROID_NDK_XSHA1CHECKSUM=50250fcba479de477b45801e2699cca47f7e1267
    export ANDROID_NDK_XNAME=android-ndk-r21d-linux-x86_64.zip
    export ANDROID_NDK_XSHA1CHECKSUM=bcf4023eb8cb6976a4c7cff0a8a8f145f162bf4d
    #export ANDROID_NDK_XNAME=android-ndk-r21e-linux-x86_64.zip
    #export ANDROID_NDK_XSHA1CHECKSUM=c3ebc83c96a4d7f539bd72c241b2be9dcd29bda9
    export ANDROID_NDK_XURL=https://dl.google.com/android/repository
fi
 
QTSRCBASENAME=qt-everywhere-src-$QT_VERSION

QTSRCRELEASE=${QTSRCBASENAME}.tar.xz

# ***************************
# JAVA_HOME

if ! [ -d "$JAVA_HOME" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
    if [ -d "$JAVA_HOME" ]; then
        echo -e "Set JAVA_HOME=[$JAVA_HOME]"
    else
        echo -e "JAVA not set and not found at [$JAVA_HOME]"
        exit 1
    fi
else
    echo -e "Use JAVA_HOME [$JAVA_HOME]"
fi

# ***************************
# create Qt root folder

mkdir -p $QTROOTFOLDER

# ***************************
# ANDROID_SDK_ROOT

if   [ -x "$(command -v $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager)"  ]; then
    echo -e "Use Android SDK in path [$ANDROID_SDK_ROOT]"
elif [ -x "$(command -v $HOME/android-sdk/cmdline-tools/tools/bin/sdkmanager)"  ]; then
    export ANDROID_SDK_ROOT=$HOME/android-sdk
    echo -e "Use exist Android SDK (tools)  [$ANDROID_SDK_ROOT]"
elif [ -x "$(command -v $HOME/android-sdk/cmdline-tools/latest/bin/sdkmanager)" ]; then
    export ANDROID_SDK_ROOT=$HOME/android-sdk
    echo -e "Use exist Android SDK (latest) [$ANDROID_SDK_ROOT]"
# elif [ -x "$(command -v /usr/lib/android-sdk/cmdline-tools/latest/bin/sdkmanager)" ]; then
#     export ANDROID_SDK_ROOT=/usr/lib/android-sdk/
#     echo -e "Use exist native Android SDK [$ANDROID_SDK_ROOT]"
else

    export ANDROID_SDK_ROOT=$ANDROID_SDK_XROOT
    
    ./installAndroidSDK.sh
    
    retval=$?; if ! [[ $retval -eq 0 ]]; then echo "Failed install Android SDK [$retval]"; exit 1; fi
    
    if   [ -x "$(command -v $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager)"  ]; then
        echo -e "Use Android SDK in path [$ANDROID_SDK_ROOT]"
    else
        echo -e "ANDROID_SDK_ROOT not set.\nAndroid sdk not found. Abort."
        exit 1
    fi
fi

# ***************************
# ANDROID_NDK_ROOT

if ! [ -x "$(command -v $ANDROID_NDK_ROOT/prebuilt/linux-x86_64/bin/make)" ]; then
    if [ -d "$ANDROID_SDK_ROOT/ndk" ]; then
        echo "Local NDK folder exist [$ANDROID_SDK_ROOT/ndk]"
        testFolder=$ANDROID_SDK_ROOT/ndk/*/
        listNdk=$(ls -d $testFolder | sort)
        echo -e "Local NDK list:\n$listNdk"
        export ANDROID_NDK_ROOT=$(echo "$listNdk" | tail -n1)
        echo -e "NDK path for test [$ANDROID_NDK_ROOT]"
        if ! [ -x "$(command -v $ANDROID_NDK_ROOT/prebuilt/linux-x86_64/bin/make)" ]; then
            echo -e "ANDROID_NDK_ROOT not set.\nAndroid ndk in path [$ANDROID_NDK_ROOT] not found. Abort."
            exit 1
        fi
    else
        echo -e "ANDROID_NDK_ROOT not set.\nAndroid ndk in path [$ANDROID_SDK_ROOT/ndk] not found. Abort."
        exit 1
    fi
fi

# ***************************
#

export PATH=$JAVA_HOME/bin:$PATH
echo -e "PATH=[$PATH]\n"

QTINSTALLDIR=$QTROOTFOLDER/$QT_VERSION
echo -e "QTINSTALLDIR=[$QTINSTALLDIR]"

QTBUILDDIR=$QTROOTFOLDER/build-$QT_VERSION
echo -e "QTBUILDDIR=[$QTBUILDDIR]"

QTSRCDIR=$QTROOTFOLDER/$QTSRCBASENAME
echo -e "QTSRCDIR=[$QTSRCDIR]"

# ***************************
# archive exist or download if not

if ! [ -f "$QTROOTFOLDER/$QTSRCRELEASE" ]; then

    echo "Download Qt source..."

    wget -N https://download.qt.io/official_releases/qt/$QT_VERSION_MAJOR/$QT_VERSION/single/$QTSRCRELEASE -P $QTROOTFOLDER
    wget -N https://download.qt.io/official_releases/qt/$QT_VERSION_MAJOR/$QT_VERSION/single/md5sums.txt -P $QTROOTFOLDER

    echo "Test [$QTROOTFOLDER/md5sums.txt]"

    INPUT=$QTROOTFOLDER/md5sums.txt
    OLDIFS=$IFS
    IFS=' '
    declare -A arr
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while read checksum filename
    do
        arr["$filename"]=$checksum
    done < $INPUT
    IFS=$OLDIFS

    echo "Test [$QTROOTFOLDER/$QTSRCRELEASE]"

    md5=`md5sum $QTROOTFOLDER/$QTSRCRELEASE`
    md5=$(echo $md5 | cut -d' ' -f 1)

    if [ $md5 != ${arr["$QTSRCRELEASE"]} ]; then
        echo "MD5 checksum failed."
        exit 1
    fi

    echo "MD5 checksum Ok."

fi

echo "Extract [$QTROOTFOLDER/$QTSRCRELEASE]"

tar -xf $QTROOTFOLDER/$QTSRCRELEASE -C $QTROOTFOLDER

echo "Prepare build and install folder..."

mkdir -p $QTINSTALLDIR
mkdir -p $QTBUILDDIR

cd $QTBUILDDIR

echo "Build [$QTSRCDIR] in [$QTBUILDDIR]"

$QTSRCDIR/configure -xplatform android-clang \
                    -prefix $QTINSTALLDIR \
                    -disable-rpath \
                    -nomake tests \
                    -nomake examples \
                    -android-sdk $ANDROID_SDK_ROOT \
                    -android-ndk $ANDROID_NDK_ROOT \
                    -no-warnings-are-errors \
                    -opensource \
                    -confirm-license

make -j$(nproc)
make -j$(nproc) install

# rm $QTROOTFOLDER/md5sums.txt
# rm $QTROOTFOLDER/$QTSRCRELEASE
# rm -rf $QTSRCDIR

PATH=$QTINSTALLDIR/bin:$PATH
