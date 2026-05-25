@echo off
:: =====================================================================
:: 🚀 N8N LOCAL AUTOMATION SANDBOX QUICKSTART RUNNER (WINDOWS)
:: =====================================================================
:: Description: Verifies Node.js, installs n8n, and boots the local server.
:: =====================================================================

title n8n Multi-Agent Local Sandbox
color 0b
cls

echo =====================================================================
echo    _  _   ___   _  _     _                      _   ___            
echo   ^| ^\_^| ^| ^| _ ^| ^| ^\_^| ^|   ^| ^|    ___   __ _  __ _^| ^| ^| _ \___ _ _  
echo   ^| ^\^| ^| ^| _/ \ ^| ^\^| ^|   ^| ^|__ / _ \_/ _` ^|/ _` ^| ^| ^|  _/ -_) ' \ 
echo   ^|_^|\_^| ^|_^|   ^|_^|\_^|   ^|____^|\___^/\__, ^|\__,_^|_^|_^|_^| ^\___^|_^|^|_^|
echo                                      ^|___/                        
echo =====================================================================
echo  [SYSTEM]: Setting up your 100%% Free Local Automation Canvas...
echo =====================================================================
echo.

:: Step 1: Check for Node.js and NPM Installation
echo 🔎 Checking Node.js installation...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    color 0c
    echo [ERROR]: Node.js is NOT installed on this machine!
    echo.
    echo Please install Node.js (which includes npm) from:
    echo   👉 https://nodejs.org
    echo.
    echo Install the recommended LTS version and then re-run this script.
    echo.
    pause
    exit /b
)
echo  [OK]: Node.js detected: & node -v
echo  [OK]: NPM detected: & npm -v
echo.

:: Step 2: Check or install n8n globally
echo 🔎 Checking if n8n is installed globally...
call n8n --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  [INFO]: n8n was not found. Installing n8n globally...
    echo          (This might take a couple of minutes, please hold on...)
    echo.
    call npm install n8n -g
    if %errorlevel% neq 0 (
        color 0c
        echo [ERROR]: Failed to install n8n globally.
        echo Try running Command Prompt as Administrator and re-running this script.
        pause
        exit /b
    )
    echo  [OK]: n8n installed successfully!
    echo.
) else (
    echo  [OK]: n8n is already installed globally: & call n8n --version
    echo.
)

:: Step 3: Boot local server
echo =====================================================================
echo 🎉 BOOTING LOCAL N8N ENGINE SERVER INSTANCE...
echo =====================================================================
echo.
echo  💡 Action Required:
echo     Once the server starts up, open your web browser and navigate to:
echo     👉 http://localhost:5678
echo.
echo  💡 Instructions:
echo     1. Create your administrative owner account on the web page.
echo     2. Import your "n8n_workflow.json" workflow.
echo     3. Press [Ctrl + C] in this terminal window to stop the server when done.
echo.
echo =====================================================================
echo.

n8n start

pause
