:: %ComSpec%

:: example
:: video_to_gif.bat 29_1_153_HDF_watch_restart.avi 30 10
:: https://ffmpeg.org/ffmpeg-utils.html#time-duration-syntax

@echo off

set "DOWNLOADS=%USERPROFILE%\Downloads"
set "LOGDIR=%DOWNLOADS%\logs"

set INPUT=%1
set FROM=%2
set LEN=%3
set OUT=%FILE%

::set "CROP=in_w:in_h:0:0"
set "CROP=809:594:578:200"
set SCALE=450
set FPS=10
set PAUSE=250

pushd %LOGDIR%

echo ffmpeg -i %INPUT% output.gif
echo ffmpeg -y -ss %FROM% -t %LEN% -i %INPUT% output_trimmed.gif
echo ffmpeg -y -ss %FROM% -t %LEN% -i %INPUT% -filter_complex "[0:v] palettegen" palette.png
echo ffmpeg -y -ss %FROM% -t %LEN% -i %INPUT% -i palette.png -filter_complex "[0:v][1:v] paletteuse" output_trimmed_enhanced.gif
echo ffmpeg -y -ss %FROM% -t %LEN% -i %INPUT% -i palette.png -filter_complex "[0:v] fps=%FPS%,scale=%SCALE%:-1 [new];[new][1:v] paletteuse" output_trimmed_enhanced_reduced.gif

@echo on

ffmpeg -y -ss %FROM% -t %LEN% -i %INPUT% -filter_complex "[0:v] crop=%CROP%,palettegen" palette.png
ffmpeg -y -ss %FROM% -t %LEN% -i %INPUT% -i palette.png -filter_complex "[0:v] crop=%CROP%,fps=%FPS%,scale=%SCALE%:-1 [new];[new][1:v] paletteuse" output_trimmed_enhanced_reduced_crop.gif

gifsicle -O3 --lossy=100 output_trimmed_enhanced_reduced_crop.gif -o output_gifsicle.gif
gifsicle -O3 --lossy=100 output_trimmed_enhanced_reduced_crop.gif "#0--2" -d%PAUSE% "#-1" -o output_gifsicle_delay.gif

@echo off

popd
