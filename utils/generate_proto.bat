@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: %~nx0 [proto_file_directory]
    exit /b 1
)

set "proto_file_directory=%~1"

REM get all proto files
call ./utils/search_files.bat %proto_file_directory% .proto file_list

REM set prefix path
for %%d in (%~dp0..) do set prefix_path=%%~fd

REM replace the prefix path to empty
set modified_proto_file_directory=!proto_file_directory:%prefix_path%\=!

REM get the first folder name
for /f "tokens=1 delims=\" %%i in ("%modified_proto_file_directory%") do (
  set first_folder=%%i
)

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

protoc --proto_path=%first_folder% --proto_path=./third_party --go_out=paths=source_relative:%first_folder% --go-grpc_out=paths=source_relative:%first_folder% %relative_file_paths%

endlocal