@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: %~nx0 [proto_file_directory]
    exit /b 1
)

set "proto_file_directory=%~1"

REM get all proto files
call ./utils/search_files.bat %proto_file_directory% .proto file_list

REM get the last folder and the prefix path
for %%i in ("%proto_file_directory%") do (
    set "last_folder=%%~nxi"
    set "prefix_path=%%~dpi"
)
set "prefix_path=%prefix_path:~0,-1%"

REM split whitespace of file_list and repalce relative path to empty of each file
set "relative_file_paths="
for %%f in (%file_list%) do (
    set "file=%%f"
    set "file=!file:%prefix_path%\=!"

    if "!relative_file_paths!"=="" (
        set "relative_file_paths=!file!"
    ) else (
        set "relative_file_paths=!relative_file_paths! !file!"
    )
)

protoc --proto_path=%last_folder% --proto_path=./third_party --go_out=paths=source_relative:%last_folder% --go-grpc_out=paths=source_relative:%last_folder% %relative_file_paths%

endlocal