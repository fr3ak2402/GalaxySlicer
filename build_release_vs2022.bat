set WP=%CD%
cd deps
mkdir build
cd build
set DEPS=%CD%/GalaxySlicer_dep

if "%1"=="slicer" (
    GOTO :slicer
)

echo "building deps.."
cmake ../ -G "Visual Studio 17 2022" -A x64 -DDESTDIR="%CD%/GalaxySlicer_dep" -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release --target deps -- -m

echo "downloading Python.."
set PY_URL=https://www.python.org/ftp/python/3.12.0/python-3.12.0-embed-amd64.zip
set PY=%WP%/deps/build/GalaxySlicer_dep

cd %PY%
mkdir python
cd python

set PY_DIR=%CD%

curl -o %PY_DIR%\python_embed.zip %PY_URL%

powershell -command "Expand-Archive -Path %PY_DIR%\python_embed.zip -DestinationPath %PY_DIR%"

del %PY_DIR%\python_embed.zip

if "%1"=="deps" exit /b 0

:slicer
echo "building GalaxySlicer..."
cd %WP%
mkdir build 
cd build

cmake .. -G "Visual Studio 17 2022" -A x64 -DBBL_RELEASE_TO_PUBLIC=1 -DCMAKE_PREFIX_PATH="%DEPS%/usr/local" -DCMAKE_INSTALL_PREFIX="./GalaxySlicer" -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release --target ALL_BUILD -- -m
cd ..
call run_gettext.bat
cd build
cmake --build . --target install --config Release

echo "copying Python..."

cd %WP%/build/GalaxySlicer
mkdir python

set PY_DEST=%CD%
set PY_DEPS=%DEPS%/python

xcopy %PY_DEPS% %PY_DEST%\python /E /I
