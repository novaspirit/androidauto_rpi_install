#!/bin/bash

##
# Script for Android Auto (OpenAuto) install on RPi
# Original install instructions https://github.com/f1xpl/openauto/wiki/Build-instructions
#
# Compatible only with Raspbeery PI 3 or newer (Stretch)
##

# Installing dependeces
whiptail --title "OpenAuto RPi" --msgbox "Installing dependences" 8 78
sudo apt-get update
sudo apt-get install -y libboost-all-dev libusb-1.0.0-dev libssl-dev cmake libprotobuf-dev protobuf-c-compiler protobuf-compiler libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev pulseaudio librtaudio-dev

cd 

# Cloning and building Android Auto SDK
whiptail --title "OpenAuto RPi" --msgbox "Cloning and building Android Auto SDK" 8 78
git clone -b master https://github.com/f1xpl/aasdk.git

mkdir aasdk_build
cd aasdk_build
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
make -j4

# Building ilclient firmware
whiptail --title "OpenAuto RPi" --msgbox "Building ilclient firmware" 8 78
cd /opt/vc/src/hello_pi/libs/ilclient
make -j4

cd

# Cloning and building OpenAuto 
whiptail --title "OpenAuto RPi" --msgbox "Cloning and building OpenAuto" 8 78
git clone -b master https://github.com/f1xpl/openauto.git

mkdir openauto_build
cd openauto_build
cmake -DCMAKE_BUILD_TYPE=Release -DRPI3_BUILD=TRUE -DAASDK_INCLUDE_DIRS="/home/pi/aasdk/include" -DAASDK_LIBRARIES="/home/pi/aasdk/lib/libaasdk.so" -DAASDK_PROTO_INCLUDE_DIRS="/home/pi/aasdk_build" -DAASDK_PROTO_LIBRARIES="/home/pi/aasdk/lib/libaasdk_proto.so" ../openauto
make -j4

# Enabling OpenAuto autostart
echo "sudo /home/pi/openauto/bin/autoapp" >> /home/pi/.config/lxsession/LXDE-pi/autostart

# Starting OpenAuto
whiptail --title "OpenAuto RPi" --msgbox "Strating OpenAuto" 8 78
/home/pi/openauto/bin/autoapp
