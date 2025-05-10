# 🧹 Windows Standby Memory Cleaner

This project provides a batch script that **automatically clears the Windows standby memory cache** using [**EmptyStandbyList**](https://github.com/stefanpejcic/EmptyStandbyList), a lightweight tool developed by [stefanpejcic](https://github.com/stefanpejcic).

Clearing standby memory can be useful on systems that experience slowdowns due to excessive memory caching, especially during gaming or heavy software usage.

---

## 🚀 How It Works

The script follows these steps:

1. **Checks for Administrator Privileges**  
   It uses a system call to verify if it has admin rights. If not, it automatically relaunches itself with elevated privileges via PowerShell.

2. **Sets the Path and Download URL**  
   It defines the local path where `EmptyStandbyList.exe` should be located and the GitHub URL where it can be downloaded if missing:  
   `https://github.com/stefanpejcic/EmptyStandbyList/raw/refs/heads/master/EmptyStandbyList.exe`

3. **Downloads the Executable If Needed**  
   If `EmptyStandbyList.exe` is not present, it downloads the file using PowerShell. If the download fails, the script stops with an error.

4. **Executes the Tool**  
   It runs the command:
   ```cmd
   EmptyStandbyList.exe standbylist

This clears the standby memory list from RAM.

5. Handles Errors and Displays Messages
The script pauses if an error occurs and exits with a non-zero code. If successful, it confirms that the standby memory has been cleared.

📦 Requirements
Windows operating system

Administrator privileges

Internet access (only needed for the first run to download EmptyStandbyList.exe)

📜 Script Content

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

📁 Credits
EmptyStandbyList by stefanpejcic
