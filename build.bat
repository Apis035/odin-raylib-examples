@echo off

if not exist bin mkdir bin

if "%1" == "clean" (
    echo Cleaning output folder...
    pushd bin
    del *.exe *.bin
    popd
    goto :eof
)

set opt=minimal
set flags=-disable-assert -no-bounds-check -subsystem:windows

if not "%1" == "" set opt=%1

echo Compiling examples with optimization set to %opt%

for /r %%` in (*.odin) do (
    echo ^> %%~nx`
    odin build %%~` -file -out:bin\%%~n`.exe -o:%opt% %flags%

    :: odin setting echo back to on, bug?
    echo off

    if "%2" == "upx" upx -qqq --lzma bin\%%~n`.exe
)