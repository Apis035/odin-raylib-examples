:: TODO:
:: - Option to compile only specific example module

@echo off

setlocal EnableDelayedExpansion

set opt=minimal
set pack=
set lld=
set flags=-disable-assert -no-bounds-check -subsystem:windows


:ParseArgs
    set arg=%1
    if "%arg%" == "" goto Build
    if "%arg%" == "help" goto Help
    if "%arg%" == "/?" goto Help
    if "%arg%" == "-h" goto Help
    if "%arg%" == "check" goto Check
    if "%arg%" == "clean" goto Clean

    for %%A in (none, minimal, speed, size, aggressive) do if %arg% == %%A set opt=%arg%
    if %arg% == upx set pack=1
    if %arg% == lld set lld=-lld

    shift
goto ParseArgs


:Build
    if defined pack (set upxmsg=true) else (set upxmsg=false)

    echo.
    echo Compiling examples...
    echo     Optimization: %opt%
    if defined pack (
    echo     UPX packing enabled
    )
    if defined lld (
    echo     Using LLD linker
    )
    echo.

    for /d %%D in (*) do (
        for %%F in (%%D\*.odin) do (
            echo ^> %%~nxF

            odin build %%F -file -out:%%~pnF.exe -o:%opt% %lld% %flags%
            if defined pack upx -qqq --lzma %%~pnF.exe
        )
    )
goto :eof


:Help
    echo %~0 [options...]
    echo.
    echo Options:
    echo     none, minimal, speed, size, aggressive
    echo         Set Odin compiler optimization mode.
    echo.
    echo     upx
    echo         Compress resulting executable with UPX.
    echo.
    echo     lld
    echo         Use LLD linker for linking.
    echo.
    echo     check
    echo         Run `odin check` on all files.
    echo.
    echo     clean
    echo         Clean all compiled files.
goto :eof

:Check
    echo.
    echo Checking examples...
    echo.
    for /d %%D in (*) do (
        for %%F in (%%D\*.odin) do (
            echo ^> %%~nxF

            odin check %%F -file
            echo off
        )
    )
goto :eof


:Clean
    echo Cleaning output files...
    del /s *.exe *.obj
goto :eof