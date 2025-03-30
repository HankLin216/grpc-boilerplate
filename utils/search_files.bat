@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: %~nx0 [directory] [pattern] [optional_output_variable]
    exit /b 1
)

if "%~2"=="" (
    echo Usage: %~nx0 [directory] [pattern] [optional_output_variable]
    exit /b 1
)

set "directory=%~1"
set "pattern=%~2"
set "result="

for /r %directory% %%f in (*.proto) do (
    set "result=!result! %%f"
)

if "%~3"=="" (
    echo %result%
)

endlocal & if not "%~3"=="" set "%~3=%result%"