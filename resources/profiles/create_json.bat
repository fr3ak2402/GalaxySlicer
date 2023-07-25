@echo off

:: Funktion zum Durchsuchen eines bestimmten Unterverzeichnisses und Erstellen der JSON-Struktur
:explore_filament
setlocal EnableDelayedExpansion
set "dir=%~1"
set "subdir=%~2"
set "indent=%~3"
set "fdm_files_common="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm_filament_common.json" 2^>nul ^| sort') do (
    set "fdm_files_common=!fdm_files_common!%%F "
)
set "fdm_files="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm*.json" ^| find /v "fdm_filament_common.json" ^| sort') do (
    set "fdm_files=!fdm_files!%%F "
)
set "other_files="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\*.json" ^| find /v "fdm*.json" ^| sort') do (
    set "other_files=!other_files!%%F "
)
set "json_string="
set "leer=      "
for %%F in (%fdm_files_common%) do (
    call :set_json_string "%%F"
)
for %%F in (%fdm_files%) do (
    call :set_json_string "%%F"
)
for %%F in (%other_files%) do (
    call :set_json_string "%%F"
)
if defined json_string (
    set "json_string=!json_string:~0,-3!"
)
echo %indent%[
echo -e %json_string%
echo %indent%]
goto :eof

:explore_process
setlocal EnableDelayedExpansion
set "dir=%~1"
set "subdir=%~2"
set "indent=%~3"
set "fdm_files_common="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm_process_common.json" 2^>nul ^| sort') do (
    set "fdm_files_common=!fdm_files_common!%%F "
)
set "fdm_files="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm*.json" ^| find /v "fdm_process_common.json" ^| sort') do (
    set "fdm_files=!fdm_files!%%F "
)
set "other_files="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\( *.json" ^| find /v "fdm*.json" ^| sort') do (
    set "other_files=!other_files!%%F "
)
set "json_string="
set "leer=      "
for %%F in (%fdm_files_common%) do (
    call :set_json_string "%%F"
)
for %%F in (%fdm_files%) do (
    call :set_json_string "%%F"
)
for %%F in (%other_files%) do (
    call :set_json_string "%%F"
)
if defined json_string (
    set "json_string=!json_string:~0,-3!"
)
echo %indent%[
echo -e %json_string%
echo %indent%]
goto :eof

:explore_machine_model_list
setlocal EnableDelayedExpansion
set "dir=%~1"
set "subdir=%~2"
set "indent=%~3"
set "files="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\*.json" ^| find /v "( *" ^| find /v "fdm*" ^| sort') do (
    set "files=!files!%%F "
)
set "json_string="
set "leer=      "
for %%F in (%files%) do (
    call :set_json_string "%%F"
)
if defined json_string (
    set "json_string=!json_string:~0,-3!"
)
echo %indent%[
echo -e %json_string%
echo %indent%]
goto :eof

:explore_machine
setlocal EnableDelayedExpansion
set "dir=%~1"
set "subdir=%~2"
set "indent=%~3"
set "fdm_files_common="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm_machine_common.json" 2^>nul ^| sort') do (
    set "fdm_files_common=!fdm_files_common!%%F "
)
set "fdm_files="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm*.json" ^| find /v "fdm_machine_common.json" ^| sort') do (
    set "fdm_files=!fdm_files!%%F "
)
set "other_files="
for /f "delims=" %%F in ('dir /b /a-d "%dir%\( *.json" ^| find /v "fdm*.json" ^| sort') do (
    set "other_files=!other_files!%%F "
)
set "json_string="
set "leer=      "
for %%F in (%fdm_files_common%) do (
    call :set_json_string "%%F"
)
for %%F in (%fdm_files%) do (
    call :set_json_string "%%F"
)
for %%F in (%other_files%) do (
    call :set_json_string "%%F"
)
if defined json_string (
    set "json_string=!json_string:~0,-3!"
)
echo %indent%[
echo -e %json_string%
echo %indent%]
goto :eof

:set_json_string
set "full_filename=%~1"
set "filename=%~nx1"
set "filename_without_extension=%~n1"
set "directory_path=%~dp1"
set "extension=%~x1"
set "name=%filename_without_extension:.=%"
set "json_string=%indent%{"
set "json_string=%json_string%\"name\": \"%filename_without_extension%,\""
set "json_string=%json_string%\"sub_path\": \"%subdir%\%filename%\""
set "json_string=%json_string%},"
goto :eof

:: Hauptskript zum Erstellen der snapmaker.json-Datei
:main
set "base_directory=%~1"
set "json_filename=%~1.json"
set "counter=1"

:: Uncomment the following block if you want to add numbering to the json_filename
:::while exist "%json_filename%" (
:::    set /a "counter+=1"
:::    set "json_filename=%~1_!counter!.json"
:::)

if not exist "%base_directory%" (
    echo Das Verzeichnis %base_directory% existiert nicht.
    exit /b 1
)

set "json_string={"
set "json_string=!json_string!"name": "%~1","
set "json_string=!json_string!"version": "01.00.00.00","
set "json_string=!json_string!"force_update": "0","
set "json_string=!json_string!"description": "%~1 configurations","
set "json_string=!json_string!"machine_model_list": ^<call :explore_machine_model_list "%base_directory%\machine" "machine" "  "^>,"
set "json_string=!json_string!"process_list": ^<call :explore_process "%base_directory%\process" "process" "  "^>,"
set "json_string=!json_string!"filament_list": ^<call :explore_filament "%base_directory%\filament" "filament" "  "^>,"
set "json_string=!json_string!"machine_list": ^<call :explore_machine "%base_directory%\machine" "machine" "  "^>"
set "json_string=!json_string!}"
echo !json_string! > "%json_filename%"

echo Die %json_filename%-Datei wurde erfolgreich erstellt!
exit /b 0
