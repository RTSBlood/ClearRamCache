@echo off
:: Check if the script is being run with administrator privileges
:: If not, restart it with admin rights

>nul 2>&1 "%SystemRoot%\system32\cacls.exe" %SystemRoot%\system32\config\system
if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Define the path of the executable
set "FILE=%~dp0EmptyStandbyList.exe"
set "URL=https://github.com/stefanpejcic/EmptyStandbyList/raw/refs/heads/master/EmptyStandbyList.exe"

:: Check if the file exists, if not, download it
if not exist "%FILE%" (
    echo The tool EmptyStandbyList.exe was not found, downloading...
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%URL%', '%FILE%')"

    if not exist "%FILE%" (
        echo Download failed!
        exit /b 1
    )
    echo Download successful.
)

:: Clear standby memory cache
echo Clearing standby memory cache...
"%FILE%" standbylist
if %errorlevel% NEQ 0 (
    echo Error while executing EmptyStandbyList.exe
    pause
    exit /b 1
)
echo Standby memory cache cleared!

pause
