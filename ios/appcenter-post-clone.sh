#!/usr/bin/env bash
#Place this script in project/ios/

echo "Uninstalling all CocoaPods versions"
sudo gem uninstall cocoapods --all --executables

COCOAPODS_VER=`sed -n -e 's/^COCOAPODS: \([0-9.]*\)/\1/p' Podfile.lock`

echo "Installing CocoaPods version $COCOAPODS_VER"
sudo gem install cocoapods -v $COCOAPODS_VER


# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
echo "Installed flutter to `pwd`/flutter"
flutter channel flutter-1.22-candidate.12
flutter doctor
flutter clean
flutter pub get

# cd ios
# pod install
# cd ..

flavorFile="lib/main-${APP_BUILD_FLAVOR}.dart"
echo "${flavorFile}"

#flutter build ios --release --no-codesign --build-name 1.0.0 --build-number 12 --flavor uat -t lib/main-uat.dart
flutter build ios --release --no-codesign --flavor $APP_BUILD_FLAVOR -t $flavorFile
