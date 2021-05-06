
if [ -z "${ANDROID_SDK_ROOT}" ];           then echo "ANDROID_SDK_ROOT not set";           exit 1; fi
if [ -z "${ANDROID_SDK_PLATFORM}" ];   then echo "ANDROID_SDK_PLATFORM not set";   exit 1; fi
if [ -z "${ANDROID_SDK_BUILDTOOLS}" ]; then echo "ANDROID_SDK_BUILDTOOLS not set"; exit 1; fi
if [ -z "${ANDROID_SDK_SOURCESDK}" ];  then echo "ANDROID_SDK_SOURCESDK not set";  exit 1; fi
if [ -z "${ANDROID_SDK_URL}" ];            then echo "ANDROID_SDK_URL not set";  exit 1; fi

if [ -z "${ANDROID_NDK_XNAME}" ];          then echo "ANDROID_NDK_XNAME not set";          exit 1; fi
if [ -z "${ANDROID_NDK_XURL}" ];           then echo "ANDROID_NDK_XURL not set";           exit 1; fi
if [ -z "${ANDROID_NDK_XSHA1CHECKSUM}" ];  then echo "ANDROID_NDK_XSHA1CHECKSUM not set";  exit 1; fi

# ******************************
# SDK
if ! [ -f "$HOME/cache/$ANDROID_SDK_SOURCESDK" ]; then
    echo -e "Valid SDK not found.\n\nDownload SDK [$ANDROID_SDK_URL/$ANDROID_SDK_SOURCESDK] to [$HOME/cache/$ANDROID_SDK_SOURCESDK]\n"
    wget -N $ANDROID_SDK_URL/$ANDROID_SDK_SOURCESDK -P $HOME/cache
    retval=$?; if ! [[ $retval -eq 0 ]]; then echo "Failed download android SDK [$retval]"; exit 1; fi
fi

echo "Unzip SDK"

mkdir -p "$HOME/.android"
touch "$HOME/.android/repositories.cfg"

mkdir -p $ANDROID_SDK_ROOT

unzip -o -qq "$HOME/cache/$ANDROID_SDK_SOURCESDK" -d "$ANDROID_SDK_ROOT/cmdline-tools";
retval=$?; if ! [[ $retval -eq 0 ]]; then echo "Failed unzip SDK [$retval]"; exit 1; fi

# rm -f "$HOME/$ANDROID_SDK_SOURCESDK"

echo -e "********************************************"
echo -e "Start install package [$ANDROID_SDK_SOURCESDK]\n"

cd $ANDROID_SDK_ROOT/cmdline-tools/tools/bin

yes | ./sdkmanager --licenses 
yes | ./sdkmanager --update
./sdkmanager "platform-tools" "platforms;$ANDROID_SDK_PLATFORM" "build-tools;$ANDROID_SDK_BUILDTOOLS"

cd -

echo -e "End install package [$ANDROID_SDK_SOURCESDK]\n"
echo -e "********************************************\n"

# ******************************
# NDK

# export ANDROID_NDK_XNAME=android-ndk-r21d-linux-x86_64.zip
# export ANDROID_NDK_XSHA1CHECKSUM=bcf4023eb8cb6976a4c7cff0a8a8f145f162bf4d
# export ANDROID_NDK_XURL="https://dl.google.com/android/repository"

if ! [ -f "$HOME/cache/$ANDROID_NDK_XNAME" ]; then
    echo -e "Valid NDK not found.\n\nDownload NDK [$ANDROID_NDK_XURL/$ANDROID_NDK_XNAME] to [$HOME/cache/$ANDROID_NDK_XNAME]\n"
    wget -N $ANDROID_NDK_XURL/$ANDROID_NDK_XNAME -P $HOME/cache
    retval=$?; if ! [[ $retval -eq 0 ]]; then echo "Failed download android NDK [$retval]"; exit 1; fi
fi
    
echo "Test checksum..."

SHA1Checksum="$ANDROID_NDK_XSHA1CHECKSUM  $HOME/cache/$ANDROID_NDK_XNAME"
SHA1ChecksumDownload=$(sha1sum $HOME/cache/$ANDROID_NDK_XNAME)
if [[ $SHA1Checksum != $SHA1ChecksumDownload ]]; then
    echo -e "Checksum failed  [$SHA1Checksum] != [$SHA1ChecksumDownload]\n"
    exit 1
else
    echo -e "Checksum OK\n[$SHA1Checksum] == [$SHA1ChecksumDownload]\n"
fi

ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk

echo -e "Unzip NDK [$HOME/cache/$ANDROID_NDK_XNAME] > [$(pwd)/tmp]\n"
unzip -o -qq "$HOME/cache/$ANDROID_NDK_XNAME" -d "$(pwd)/tmp";

# rm -f "$HOME/cache/$ANDROID_NDK_XNAME"

listNdkTmpDir=$(ls -d tmp/*/ | sort)
echo -e "List Ndk in 'tmp' [$listNdkTmpDir]"

verfile=$(echo "$listNdkTmpDir" | tail -n1)
echo -e "Path to NDK [$verfile]"

verfile=${verfile}/source.properties
echo -e "Path to NDK version file [$verfile]"

while IFS='=' read -r key value
do
    key=$(echo $key | tr '.' '_')
    value="$(echo $value | sed -e 's/^[[:space:]]*//')"
    value="$(echo $value | sed -e 's/[[:space:]]*$//')"
    eval ${key}=\${value}
done < "$verfile"

echo "NDK revision [$Pkg_Revision]"


rm -rf "$ANDROID_NDK_ROOT"

mv -v $(pwd)/tmp/android-ndk-r* $ANDROID_NDK_ROOT
retval=$?; if ! [[ $retval -eq 0 ]]; then echo "Failed [$retval]"; exit 1; fi

export ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT}/${Pkg_Revision}"
echo "Set ANDROID_NDK_ROOT=[$ANDROID_NDK_ROOT]"

printf %s "$ANDROID_NDK_ROOT" > tmp.ANDROID_NDK_ROOT.txt
