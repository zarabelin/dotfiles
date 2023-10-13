#!/bin/bash

SINK_NAME=combined-app-sink
VIRTUAL_MIC_NAME=my-virtualmic
MIC_SOURCE=alsa_input.usb-046d_Logitech_StreamCam_901DCE45-02.analog-stereo

results=$(pw-link -o | grep ${1})
IFS=$'\n' read -ra ADDR -d $'\0' <<< "$results"

# Unload if exists
pactl unload-module module-null-sink

# Make new sinks
pactl load-module module-null-sink media.class=Audio/Sink sink_name=$SINK_NAME channel_map=stereo >> /dev/null
pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=$VIRTUAL_MIC_NAME channel_map=front-left,front-right >> /dev/null

# Extract app name
IFS=':'
read -a APP_STR <<< ${ADDR[0]}
echo "Linking app ${APP_STR} to ${SINK_NAME}"
pw-link "${APP_STR}":output_FL $SINK_NAME:playback_FL
pw-link "${APP_STR}":output_FR $SINK_NAME:playback_FR

echo "Linking $MIC_SOURCE to ${SINK_NAME}"
pw-link $MIC_SOURCE:capture_FL  $SINK_NAME:playback_FL
pw-link $MIC_SOURCE:capture_FR  $SINK_NAME:playback_FR

echo "Creating virtual mic: $VIRTUAL_MIC_NAME"
pw-link $SINK_NAME:monitor_FL $VIRTUAL_MIC_NAME:input_FL
pw-link $SINK_NAME:monitor_FR $VIRTUAL_MIC_NAME:input_FR
