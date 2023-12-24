:: Build flags:
::     none minimal speed size aggressive
::     upx bin clean

:: FIXME:
:: - Odin modifying command echoing setting
:: TODO:
:: - Option to compile only specific example module
:: - Help message

@echo off

set opt=minimal
set pack=
set flags=-disable-assert -no-bounds-check -subsystem:windows


:ParseArgs
    set arg=%1
    if "%arg%" == "" goto Build
    if "%arg%" == "clean" goto Clean

    for %%A in (none, minimal, speed, size, aggressive) do if %arg% == %%A set opt=%arg%
    if %arg% == upx set pack=1

    shift
goto ParseArgs


:Build
    if defined pack (set upxmsg=true) else (set upxmsg=false)

    echo.
    echo Compiling examples...
    echo     Optimization: %opt%
    echo     UPX packing:  %upxmsg%
    echo.

    if not exist bin md bin

    for /d %%D in (*) do (
        for %%F in (%%D\*.odin) do (
            echo ^> %%~nxF

            odin build %%F -file -out:%%~pnF.exe -o:%opt% %flags%
            echo off
            if defined pack upx -qqq --lzma bin\%%~nF.exe
        )
    )

    goto :eof


:Clean
    echo Cleaning output files...
    del /s *.exe