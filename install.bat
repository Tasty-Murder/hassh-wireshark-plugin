@echo off
setlocal

set "DEST=%APPDATA%\Wireshark\plugins\hassh"

if not exist "hassh.lua" (
    echo Error: Run this script from the project root (where hassh.lua lives^).
    exit /b 1
)

if not exist "%DEST%" mkdir "%DEST%"
if not exist "%DEST%\lib" mkdir "%DEST%\lib"

copy /y hassh.lua "%DEST%\"
copy /y lib\md5.lua "%DEST%\lib\"

echo Installed to: %DEST%
echo Restart Wireshark, then go to Analyze ^> Reload Lua Plugins.

endlocal
