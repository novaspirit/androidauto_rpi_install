#!/bin/bash

##
# Script for Android Auto (OpenAuto) install on RPi
# Original install instructions https://github.com/f1xpl/openauto/wiki/Build-instructions
#
# Compatible only with Raspbeery PI 3 or newer (Stretch)
##

echo "> Updating repository"
sudo apt-get update

echo "> Installing dependences"
sudo apt-get install -y libboost-all-dev libusb-1.0.0-dev libssl-dev cmake libprotobuf-dev protobuf-c-compiler protobuf-compiler libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev pulseaudio

cd 

echo "> Cloning Android Auto SDK"
git clone -b master https://github.com/f1xpl/aasdk.git

echo "> Building Android Auto SDK"
mkdir aasdk_build
cd aasdk_build
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
make -j4

echo "> Building ilclient firmware"
cd /opt/vc/src/hello_pi/libs/ilclient
make -j4

cd

echo "> Cloning OpenAuto"
git clone -b master https://github.com/f1xpl/openauto.git

echo "> Building OpenAuto"
mkdir openauto_build
cd openauto_build
cmake -DCMAKE_BUILD_TYPE=Release -DRPI3_BUILD=TRUE -DAASDK_INCLUDE_DIRS="/home/pi/aasdk/include" -DAASDK_LIBRARIES="/home/pi/aasdk/lib/libaasdk.so" -DAASDK_PROTO_INCLUDE_DIRS="/home/pi/aasdk_build" -DAASDK_PROTO_LIBRARIES="/home/pi/aasdk/lib/libaasdk_proto.so" ../openauto
make -j4

echo "> Enabling OpenAuto autostart"
echo "sudo /home/pi/openauto/bin/autoapp" >> /home/pi/.config/lxsession/LXDE-pi/autostart

echo "> Starting OpenAuto"
/home/pi/openauto/bin/autoapp
