@echo off

rem Set the Flutter project directory, app name, and output directory
set APP_NAME=%1
set OUTPUT_DIR=C:\Users\safva\OneDrive\Desktop\Recovery\generated-apk
set OUTPUT_FILE_NAME=%APP_NAME%.apk
set LOG_FILE=move_log.txt

rem Move the generated APK to the desired location with the desired name
move build\app\outputs\flutter-apk\app-release.apk %OUTPUT_DIR%\%OUTPUT_FILE_NAME% >> %LOG_FILE% 2>&1

rem Check if the move was successful
if %errorlevel% neq 0 (
    echo Move failed for %APP_NAME%. >> %LOG_FILE%
    exit /b 1
)

echo Move successful for %APP_NAME%. APK moved to %OUTPUT_DIR%\%OUTPUT_FILE_NAME% >> %LOG_FILE%
