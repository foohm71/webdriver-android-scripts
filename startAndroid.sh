#!/bin/bash

SDK=$HOME/android-sdk-macosx
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

# This starts the emulator 
echo "Starting emulator with avd $AVD and console port $CONSOLE_PORT"
$TOOLS/emulator -avd $AVD -port $CONSOLE_PORT -no-boot-anim -noaudio &
#$TOOLS/emulator -avd $AVD -port $CONSOLE_PORT -no-boot-anim -noaudio -no-window &
#$TOOLS/emulator -avd android23 -ports 8881,8882  -proppersist.sys.language=en -prop persist.sys.country=us

# This waits for emulator to start up
echo "Waiting for emulator to boot complete"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT wait-for-device
BOOTCOMPLETE=`$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT shell getprop dev.bootcomplete`
while [[ $BOOTCOMPLETE == '' ]]
do
   BOOTCOMPLETE=`$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT shell getprop dev.bootcomplete`
   echo "WAIT" $BOOTCOMPLETE
   sleep 2
done

# This uninstalls the previous version of the WebDriver app and installs the new version
echo "Uninstalling WebDriver apk"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT uninstall org.openqa.selenium.android.app

echo "Installing WebDriver apk"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT install $APK_DIR/android-server.apk

echo "Getting out of home screen"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT shell input keyevent 82
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT shell input keyevent 4

# Port mapping
echo "Activating WebDriver app"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT shell am start -a android.intent.action.MAIN -n org.openqa.selenium.android.app/.MainActivity

sleep 10

echo "Setting up port forwarding"
$PLATFORM_TOOLS/adb -s emulator-$CONSOLE_PORT forward tcp:$LISTENER_PORT tcp:8080

echo "Starting up socat"
#socat/socat TCP-LISTEN:$SOCAT_PORT,fork TCP:localhost:$LISTENER_PORT
