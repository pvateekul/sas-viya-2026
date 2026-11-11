@echo off
setlocal

REM Set repository folder and branch
set "FLD=dgu"
set "BRANCH=main"
REM set "BRANCH=2026.09"

REM Change to the C drive root
cd /d C:\
if errorlevel 1 exit /b 1

dir

REM Keep an existing repository unchanged
if exist "C:\%FLD%\.git" (
    echo Repository already exists. Skipping clone.
    goto inspect
)

if exist "C:\%FLD%" (
    echo ERROR: C:\%FLD% exists but is not a Git repository.
    exit /b 1
)

REM Clone the specified branch
git clone --branch "%BRANCH%" --single-branch --depth 1 "https://gelgitlab.race.sas.com/GEL/edu/dm1/%FLD%.git"
if errorlevel 1 (
    echo ERROR: Git clone failed.
    exit /b 1
)

:inspect
cd /d "C:\%FLD%"
if errorlevel 1 exit /b 1

dir

REM Disable paging for this command only
git --no-pager branch -a
if errorlevel 1 exit /b 1

echo.
echo Repository is available at C:\%FLD%
endlocal