@echo off
setlocal enabledelayedexpansion

REM Funktion zum Durchsuchen eines bestimmten Unterverzeichnisses und Erstellen der JSON-Struktur
:explore_filament
set "dir=%~1"
set "subdir=%~2"
set "indent=%~3"
set "fdm_files_common="
set "fdm_files="
set "other_files="
set "json_string="
set "leer=      "

for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm_filament_common.json"') do (
    set "fdm_files_common=!fdm_files_common!%dir%\%%F,"
)

for /f "delims=" %%F in ('dir /b /a-d "%dir%\fdm*.json" ^| findstr /v /i "fdm_filament_common.json"') do (
    set "fdm_files=!fdm_files!%dir%\%%F,"
)

for /f "delims=" %%F in ('dir /b /a-d "%dir%\*.json" ^| findstr /v /i "fdm*.json"') do (
    set "other_files=!other_files!%dir%\%%F,"
)

set "json_string="
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
    set "json_string=!json_string:~0,-1!" REM Entferne das letzte Komma
)

echo %indent%[
echo %json_string%
echo %indent%]
goto :eof

:set_json_string
set "full_filename=%~1"
set "filename=%~nx1"
set "filename_without_extension=%~n1"
set "directory_path=%~dp1"
set "extension=%~x1"
set "filename=%filename: =_%"
set "name=!filename:~0,-5!"
set "json_string=!json_string!!indent!{"
set "json_string=!json_string!"name": "!name!","
set "json_string=!json_string!"sub_path": "%subdir%\!filename!""
set "json_string=!json_string!},"
goto :eof


REM explore_process und explore_machine_model_list sind analog zu explore_filament, aber mit entsprechendem Namen.
REM (Wird nicht weiter oben wiederholt, um den Text kompakt zu halten.)

REM Hauptskript zum Erstellen der snapmaker.json-Datei
set "base_directory=%~1"
set "json_filename=%~1.json"
set "counter=1"

REM while exist "%json_filename%" (
REM     set /a counter+=1
REM     set "json_filename=%~1_!counter!.json"
REM )

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
