#!/bin/bash

SDK=$HOME/android-sdks
TOOLS=$SDK/tools
PLATFORM_TOOLS=$SDK/platform-tools
APK_DIR=./apk
AVD_DIR=$HOME
AVD=android41
CONSOLE_PORT=5556
LISTENER_PORT=50001
SOCAT_PORT=9000

# Set-up ANDROID_SDK_HOME
export ANDROID_SDK_HOME=$AVD_DIR


echo "Killing WebDriver app"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT shell am force-stop org.openqa.selenium.android.app

sleep 3

# Port mapping
echo "Activating WebDriver app"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT shell am start -a android.intent.action.MAIN -n org.openqa.selenium.android.app/.MainActivity

sleep 10

echo "Setting up port forwarding"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT forward tcp:$LISTENER_PORT tcp:8080

