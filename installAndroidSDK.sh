
if [ -z "${ANDROID_SDK_ROOT}" ];           then echo "ANDROID_SDK_ROOT not set";           exit 1; fi
if [ -z "${ANDROID_SDK_PLATFORM_VER}" ];   then echo "ANDROID_SDK_PLATFORM_VER not set";   exit 1; fi
if [ -z "${ANDROID_SDK_BUILDTOOLS_VER}" ]; then echo "ANDROID_SDK_BUILDTOOLS_VER not set"; exit 1; fi
if [ -z "${ANDROID_SDK_SOURCESDK_VER}" ];  then echo "ANDROID_SDK_SOURCESDK_VER not set";  exit 1; fi

if [ -z "${ANDROID_NDK_XNAME}" ];          then echo "ANDROID_NDK_XNAME not set";          exit 1; fi
if [ -z "${ANDROID_NDK_XURL}" ];           then echo "ANDROID_NDK_XURL not set";           exit 1; fi
if [ -z "${ANDROID_NDK_XSHA1CHECKSUM}" ];  then echo "ANDROID_NDK_XSHA1CHECKSUM not set";  exit 1; fi

# ******************************
# SDK
if ! [ -f "$HOME/$ANDROID_SDK_SOURCESDK_VER" ]; then
    echo "Download android SDK"
    curl -L -k -s -o "$HOME/$ANDROID_SDK_SOURCESDK_VER" https://dl.google.com/android/repository/$ANDROID_SDK_SOURCESDK_VER;
fi

echo "Unzip SDK"

mkdir -p "$HOME/.android"
touch "$HOME/.android/repositories.cfg"

mkdir -p $ANDROID_SDK_ROOT

unzip -qq "$HOME/$ANDROID_SDK_SOURCESDK_VER" -d "$ANDROID_SDK_ROOT/cmdline-tools";

rm -f "$HOME/$ANDROID_SDK_SOURCESDK_VER"

echo "Installing packages [$ANDROID_SDK_SOURCESDK_VER]"

cd $ANDROID_SDK_ROOT/cmdline-tools/tools/bin

yes | ./sdkmanager --licenses 
yes | ./sdkmanager --update
./sdkmanager "platform-tools" "platforms;$ANDROID_SDK_PLATFORM_VER" "build-tools;$ANDROID_SDK_BUILDTOOLS_VER"

cd -

# ******************************
# NDK

# export ANDROID_NDK_XNAME=android-ndk-r21d-linux-x86_64.zip
# export ANDROID_NDK_XSHA1CHECKSUM=bcf4023eb8cb6976a4c7cff0a8a8f145f162bf4d
# export ANDROID_NDK_XURL="https://dl.google.com/android/repository"

if ! [ -f "$HOME/$ANDROID_NDK_XNAME" ]; then
    echo -e "Valid NDK not found.\nDownload NDK from [$ANDROID_NDK_XURL] to [$HOME/$ANDROID_NDK_XNAME]"
    curl -L -k -s -o "$HOME/$ANDROID_NDK_XNAME" $ANDROID_NDK_XURL/$ANDROID_NDK_XNAME;
fi

SHA1Checksum="$ANDROID_NDK_XSHA1CHECKSUM  $HOME/$ANDROID_NDK_XNAME"
SHA1ChecksumDownload=$(sha1sum $HOME/$ANDROID_NDK_XNAME)
if [[ $SHA1Checksum != $SHA1ChecksumDownload ]]; then
echo "Checksum failed  [$SHA1Checksum] != [$SHA1ChecksumDownload]"
exit 1
else
echo "Checksum OK  [$SHA1Checksum] == [$SHA1ChecksumDownload]"
fi

export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk

echo "Unzip NDK [$HOME/$ANDROID_NDK_XNAME] > [$(pwd)/tmp]"
unzip -qq "$HOME/$ANDROID_NDK_XNAME" -d "$(pwd)/tmp";

listNdkTmpDir=$(ls -d tmp/*/ | sort)
echo "List Ndk in 'tmp' [$listNdkTmpDir]"

verfile=$(echo "$listNdkTmpDir" | tail -n1)
echo "Path to NDK [$verfile]"

verfile=${verfile}/source.properties
echo "Path to NDK version file [$verfile]"

while IFS='=' read -r key value
do
key=$(echo $key | tr '.' '_')
value="$(echo $value | sed -e 's/^[[:space:]]*//')"
value="$(echo $value | sed -e 's/[[:space:]]*$//')"
eval ${key}=\${value}
done < "$verfile"

echo "NDK revision [$Pkg_Revision]"

export ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT}/${Pkg_Revision}"
echo "Set ANDROID_NDK_ROOT=[$ANDROID_NDK_ROOT]"

mv -v $(pwd)/tmp/android-ndk-r* "$ANDROID_NDK_ROOT"

