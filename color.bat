::
:: Example of outputting coloured text

@echo off
cls
setlocal enabledelayedexpansion

call :setESC

set useColor=true

set color_primary=Blue
set color_mute=Gray
set color_info=Yellow
set color_success=Green
set color_warn=DarkYellow
set color_error=Red


call :WriteLine "Predefined colors on default background"
call :WriteLine

call :WriteLine "  Default colored text"
call :WriteLine "  Primary colored text" %color_primary%
call :WriteLine "  Mute colored text"    %color_mute%
call :WriteLine "  Info colored text"    %color_info%
call :WriteLine "  Success colored text" %color_success%
call :WriteLine "  Warning colored text" %color_warn%
call :WriteLine "  Error colored text"   %color_error%

call :WriteLine
call :WriteLine "Default color on predefined background"
call :WriteLine

call :WriteLine "  Default colored background" "Default"
call :WriteLine "  Primary colored background" "Default" %color_primary%
call :WriteLine "  Mute colored background"    "Default" %color_mute%
call :WriteLine "  Info colored background"    "Default" %color_info%
call :WriteLine "  Success colored background" "Default" %color_success%
call :WriteLine "  Warning colored background" "Default" %color_warn%
call :WriteLine "  Error colored background"   "Default" %color_error%

call :WriteLine
call :WriteLine "Default contrasting color on predefined background"
call :WriteLine

call :WriteLine "  Primary colored background" "Contrast" %color_primary%
call :WriteLine "  Mute colored background"    "Contrast" %color_mute%
call :WriteLine "  Info colored background"    "Contrast" %color_info%
call :WriteLine "  Success colored background" "Contrast" %color_success%
call :WriteLine "  Warning colored background" "Contrast" %color_warn%
call :WriteLine "  Error colored background"   "Contrast" %color_error%

call :WriteLine
call :WriteLine "Each color on the default background"
call :WriteLine

call :WriteLine "  Default foreground"     
call :WriteLine "  Black foreground"       "Black"
call :WriteLine "  DarkRed foreground"     "DarkRed"
call :WriteLine "  DarkGreen foreground"   "DarkGreen"
call :WriteLine "  DarkYellow foreground"  "DarkYellow"
call :WriteLine "  DarkBlue foreground"    "DarkBlue"
call :WriteLine "  DarkMagenta foreground" "DarkMagenta"
call :WriteLine "  DarkCyan foreground"    "DarkCyan"
call :WriteLine "  Gray foreground"        "Gray"
call :WriteLine "  DarkGray foreground"    "DarkGray"
call :WriteLine "  Red foreground"         "Red"
call :WriteLine "  Green foreground"       "Green"
call :WriteLine "  Yellow foreground"      "Yellow"
call :WriteLine "  Blue foreground"        "Blue"
call :WriteLine "  Magenta foreground"     "Magenta"
call :WriteLine "  Cyan foreground"        "Cyan"
call :WriteLine "  White foreground"       "White"


call :WriteLine
call :WriteLine

call :WriteLine "        Setting up CodeProject.SenseAI Development Environment          " "DarkYellow" "White"
call :WriteLine ".                                                                      ." "White"      "White"
call :WriteLine "========================================================================" "DarkGreen"  "White"
call :WriteLine ".                                                                      ." "White"      "White"
call :WriteLine ".                 CodeProject SenseAI Installer                        ." "DarkGreen"  "White"
call :WriteLine ".                                                                      ." "White"      "White"
call :WriteLine "========================================================================" "DarkGreen"  "White"
call :WriteLine ".                                                                      ." "White"      "White"

goto:eof

:: sub-routines

:: Sets up the ESC string for use later in this script
:setESC
    for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
      set ESC=%%b
      exit /B 0
    )
    exit /B 0


:: Sets the name of a color that will providing a contrasting foreground
:: color for the given background color.
::
:: string background color name. 
:: on return, contrastForeground will be set
:setContrastForeground

    set background=%~1

    if "!background!"=="" background=Black

    if /i "!background!"=="Black"       set contrastForeground=White
    if /i "!background!"=="DarkRed"     set contrastForeground=White
    if /i "!background!"=="DarkGreen"   set contrastForeground=White
    if /i "!background!"=="DarkYellow"  set contrastForeground=White
    if /i "!background!"=="DarkBlue"    set contrastForeground=White
    if /i "!background!"=="DarkMagenta" set contrastForeground=White
    if /i "!background!"=="DarkCyan"    set contrastForeground=White
    if /i "!background!"=="Gray"        set contrastForeground=Black
    if /i "!background!"=="DarkGray"    set contrastForeground=White
    if /i "!background!"=="Red"         set contrastForeground=White
    if /i "!background!"=="Green"       set contrastForeground=White
    if /i "!background!"=="Yellow"      set contrastForeground=Black
    if /i "!background!"=="Blue"        set contrastForeground=White
    if /i "!background!"=="Magenta"     set contrastForeground=White
    if /i "!background!"=="Cyan"        set contrastForeground=Black
    if /i "!background!"=="White"       set contrastForeground=Black

    exit /B 0


:: Sets the currentColor global for the given foreground/background colors
:: currentColor must be output to the terminal before outputing text in
:: order to generate a colored output.
::
:: string foreground color name. Optional if no background provided.
::        Defaults to "White"
:: string background color name.  Optional. Defaults to Black.
:setColor

    REM If you want to get a little fancy then you can also try
    REM  - %ESC%[4m - Underline
    REM  - %ESC%[7m - Inverse

    set foreground=%~1
    set background=%~2

    if "!foreground!"=="" set foreground=White
    if /i "!foreground!"=="Default" set foreground=White
    if "!background!"=="" set background=Black
    if /i "!background!"=="Default" set background=Black

    if "!ESC!"=="" call :setESC

    if /i "!foreground!"=="Contrast" (
		call :setContrastForeground !background!
		set foreground=!contrastForeground!
	)

    set currentColor=

    REM Foreground Colours
    if /i "!foreground!"=="Black"       set currentColor=!ESC![30m
    if /i "!foreground!"=="DarkRed"     set currentColor=!ESC![31m
    if /i "!foreground!"=="DarkGreen"   set currentColor=!ESC![32m
    if /i "!foreground!"=="DarkYellow"  set currentColor=!ESC![33m
    if /i "!foreground!"=="DarkBlue"    set currentColor=!ESC![34m
    if /i "!foreground!"=="DarkMagenta" set currentColor=!ESC![35m
    if /i "!foreground!"=="DarkCyan"    set currentColor=!ESC![36m
    if /i "!foreground!"=="Gray"        set currentColor=!ESC![37m
    if /i "!foreground!"=="DarkGray"    set currentColor=!ESC![90m
    if /i "!foreground!"=="Red"         set currentColor=!ESC![91m
    if /i "!foreground!"=="Green"       set currentColor=!ESC![92m
    if /i "!foreground!"=="Yellow"      set currentColor=!ESC![93m
    if /i "!foreground!"=="Blue"        set currentColor=!ESC![94m
    if /i "!foreground!"=="Magenta"     set currentColor=!ESC![95m
    if /i "!foreground!"=="Cyan"        set currentColor=!ESC![96m
    if /i "!foreground!"=="White"       set currentColor=!ESC![97m
    if "!currentColor!"=="" set currentColor=!ESC![97m
	
    if /i "!background!"=="Black"       set currentColor=!currentColor!!ESC![40m
    if /i "!background!"=="DarkRed"     set currentColor=!currentColor!!ESC![41m
    if /i "!background!"=="DarkGreen"   set currentColor=!currentColor!!ESC![42m
    if /i "!background!"=="DarkYellow"  set currentColor=!currentColor!!ESC![43m
    if /i "!background!"=="DarkBlue"    set currentColor=!currentColor!!ESC![44m
    if /i "!background!"=="DarkMagenta" set currentColor=!currentColor!!ESC![45m
    if /i "!background!"=="DarkCyan"    set currentColor=!currentColor!!ESC![46m
    if /i "!background!"=="Gray"        set currentColor=!currentColor!!ESC![47m
    if /i "!background!"=="DarkGray"    set currentColor=!currentColor!!ESC![100m
    if /i "!background!"=="Red"         set currentColor=!currentColor!!ESC![101m
    if /i "!background!"=="Green"       set currentColor=!currentColor!!ESC![102m
    if /i "!background!"=="Yellow"      set currentColor=!currentColor!!ESC![103m
    if /i "!background!"=="Blue"        set currentColor=!currentColor!!ESC![104m
    if /i "!background!"=="Magenta"     set currentColor=!currentColor!!ESC![105m
    if /i "!background!"=="Cyan"        set currentColor=!currentColor!!ESC![106m
    if /i "!background!"=="White"       set currentColor=!currentColor!!ESC![107m

    exit /B 0

:: Outputs a line, including linefeed, to the terminal using the given foreground / background
:: colors 
::
:: string The text to output. Optional if no foreground provided. Default is just a line feed.
:: string Foreground color name. Optional if no background provided. Defaults to "White"
:: string Background color name. Optional. Defaults to "Black"
:WriteLine
    SetLocal EnableDelayedExpansion
	
    if "!ESC!"=="" call :setESC	
    set resetColor=!ESC![0m

    set str=%~1

    if "!str!"=="" (
        echo:
        exit /b 0
    )
    if "!str: =!"=="" (
        echo:
        exit /b 0
    )

    if /i "%useColor%"=="true" (
        call :setColor %2 %3
        echo !currentColor!!str!!resetColor!
    ) else (
        echo !str!
    )
    exit /b 0

:: Outputs a line without a linefeed to the terminal using the given foreground / background colors 
::
:: string The text to output. Optional if no foreground provided. Default is just a line feed.
:: string Foreground color name. Optional if no background provided. Defaults to "White"
:: string Background color name. Optional. Defaults to "Black"
:Write
    SetLocal EnableDelayedExpansion
	
    if "!ESC!"=="" call :setESC
    set resetColor=!ESC![0m

    set str=%~1

    if "!str!"=="" exit /b 0
    if "!str: =!"=="" exit /b 0

    if /i "%useColor%"=="true" (
        call :setColor %2 %3
        <NUL set /p =!currentColor!!str!!resetColor!
    ) else (
        <NUL set /p =!str!
    )
    exit /b 0
