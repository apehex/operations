#!/bin/bash

ffmpeg -video_size 1024x768 -framerate 10 -f x11grab -i :0.0+448,156 "${1:-output.mp4}"
