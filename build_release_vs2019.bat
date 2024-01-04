set WP=%CD%
cd deps
mkdir build
cd build
set DEPS=%CD%/GalaxySlicer_dep

if "%1"=="slicer" (
    GOTO :slicer
)

echo "building deps.."
cmake ../ -G "Visual Studio 16 2019" -DDESTDIR="%CD%/GalaxySlicer_dep" -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release --target deps -- -m

echo "downloading python.."
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

cmake .. -G "Visual Studio 16 2019" -DBBL_RELEASE_TO_PUBLIC=1 -DCMAKE_PREFIX_PATH="%DEPS%/usr/local" -DCMAKE_INSTALL_PREFIX="./GalaxySlicer" -DCMAKE_BUILD_TYPE=Release -DWIN10SDK_PATH="C:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0"
cmake --build . --config Release --target ALL_BUILD -- -m
cd ..
call run_gettext.bat
cd build
cmake --build . --target install --config Release

echo "copying Python..."

cd %WP%/build/GalaxySlicer
mkdir python
cd python

set PY_DEST=%CD%
set PY_DEPS=%WP%\deps\build\GalaxySlicer_dep\python

powershell -command "Copy-Item -Path %PY_DEPS%\* -Destination %PY_DEST% -Recurse"

echo "create System folders..."

cd %WP%/build/GalaxySlicer
mkdir applications

echo "building complete..."
