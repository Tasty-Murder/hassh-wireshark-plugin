@echo off
setlocal

set "DEST=%APPDATA%\Wireshark\plugins\hassh"

if exist "%DEST%" (
    rmdir /s /q "%DEST%"
    echo Uninstalled from: %DEST%
) else (
    echo Nothing to uninstall: %DEST% does not exist.
)

endlocal
