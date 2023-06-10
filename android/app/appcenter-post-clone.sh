#!/usr/bin/env bash
#Place this script in project/android/app/

cd ..

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=$(pwd)/flutter/bin:$PATH
echo "Installed flutter to $(pwd)/flutter"

flutter channel flutter-1.22-candidate.12
flutter doctor
flutter clean
# ls
# cd android
# ls
# rm  ./gradlew
# ls
flutter pub get

flavorFile="lib/main-${APP_BUILD_FLAVOR}.dart"
echo "${flavorFile}"

# build APK
flutter build apk --release --flavor $APP_BUILD_FLAVOR -t $flavorFile

releaseFile="build/app/outputs/flutter-apk/app-${APP_BUILD_FLAVOR}-release.apk"
echo "${releaseFile}"
# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/
mv $releaseFile $_
