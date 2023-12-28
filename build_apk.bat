@echo off

rem Set the Flutter project directory, app name, and output directory
set FLUTTER_PROJECT_DIR=%1
set APP_NAME=%2
set OUTPUT_DIR=%3
set OUTPUT_FILE_NAME=%APP_NAME%.apk
set LOG_FILE=build_log.txt

rem Navigate to the Flutter project directory
cd %FLUTTER_PROJECT_DIR%

rem Run Flutter build command to generate the APK and redirect output to a log file
flutter build apk >> %LOG_FILE% 2>&1

rem Check if the build was successful
if %errorlevel% neq 0 (
    echo Flutter build failed for %APP_NAME%. >> %LOG_FILE%
    exit /b 1
)

rem Move the generated APK to the desired location with the desired name
move build\app\outputs\flutter-apk\app-release.apk %OUTPUT_DIR%\%OUTPUT_FILE_NAME% >> %LOG_FILE% 2>&1

echo Build successful for %APP_NAME%. APK moved to %OUTPUT_DIR%\%OUTPUT_FILE_NAME% >> %LOG_FILE%