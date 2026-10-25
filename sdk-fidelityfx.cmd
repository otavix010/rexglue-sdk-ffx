@echo off
rem Builds the ReXGlue SDK (rexglue-src, the nightly's commit) with AMD FidelityFX into rexglue-sdk-ffx\win-amd64:
rem the same layout as the released SDK, so a port builds against it unchanged.
setlocal
set "ROOT=%~dp0"
set "LLVM=%ROOT%llvm\clang+llvm-23.1.3-x86_64-pc-windows-msvc\bin"
for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath`) do set "VS=%%i"
call "%VS%\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64 >nul || exit /b 1
set "PATH=%LLVM%;%PATH%"
cd /d "%ROOT%rexglue-src"
if not exist "%ROOT%rexglue-build\build.ninja" (
    cmake -S . -B "%ROOT%rexglue-build" -G Ninja -DCMAKE_BUILD_TYPE=Release ^
        -DCMAKE_C_COMPILER="%LLVM%\clang.exe" -DCMAKE_CXX_COMPILER="%LLVM%\clang++.exe" ^
        -DCMAKE_C_FLAGS="-march=x86-64-v2" -DCMAKE_CXX_FLAGS="-march=x86-64-v2" -DCMAKE_CXX_STANDARD=23 ^
        -DREXGLUE_ENABLE_FIDELITYFX=ON -DREXGLUE_ENABLE_TRACY=ON ^
        -DCMAKE_INSTALL_PREFIX="%ROOT%rexglue-sdk-ffx\win-amd64" || exit /b 1
)
cmake --build "%ROOT%rexglue-build" --parallel 12 || exit /b 1
cmake --install "%ROOT%rexglue-build" || exit /b 1
echo pronto: rexglue-sdk-ffx\win-amd64
