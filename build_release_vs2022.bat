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