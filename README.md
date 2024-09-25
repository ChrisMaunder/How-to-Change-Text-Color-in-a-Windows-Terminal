# How to Change Text Color in a Windows Terminal

A quick overview and a simple Windows CMD script to make your terminal output a little more lively

- [Download source code - 1.9 KB](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Windows-Terminal/master/docs/assets/color.zip)

## Introduction

The default text output to a terminal is monochromatic and doesn't provide a simple method to provide context. For instance, you may want an error to appear in red, success in green, or important info to be output in bold.

Adding color to your terminal output is straightforward and involves outputting the correct control characters before your text.

This is a companion article to [How to change text color in a Linux terminal](https://www.codeproject.com/Articles/5329247/How-to-change-text-color-in-a-Linux-terminal).

## Terminal Colors

To output colored text, you need to `echo `the control characters for the required color, then output your text, and then (to be tidy) reset the output back to defaults. The following table lists the codes:




| Color | Foreground | Background |
| --- | --- | --- |
| Default | **ESC**[39m | **ESC**[49m |
| Black | **ESC**[30m | **ESC**[40m |
| Dark red | **ESC**[31m | **ESC**[41m |
| Dark green | **ESC**[32m | **ESC**[42m |
| Dark yellow (Orange-ish) | **ESC**[33m | **ESC**[43m |
| Dark blue | **ESC**[34m | **ESC**[44m |
| Dark magenta | **ESC**[35m | **ESC**[45m |
| Dark cyan | **ESC**[36m | **ESC**[46m |
| Light gray | **ESC**[37m | **ESC**[47m |
| Dark gray | **ESC**[90m | **ESC**[100m |
| Red | **ESC**[91m | **ESC**[101m |
| Green | **ESC**[92m | **ESC**[101m |
| Orange | **ESC**[93m | **ESC**[103m |
| Blue | **ESC**[94m | **ESC**[104m |
| Magenta | **ESC**[95m | **ESC**[105m |
| Cyan | **ESC**[96m | **ESC**[106m |
| White | **ESC**[97m | **ESC**[107m |

and the reset code is **ESC**[0m where **ESC** is the escape code.

The format of the string for foreground color is:

```cpp
"ESC[" + "<0 or 1, meaning normal or bold>;" + "<color code> + "m"
```

and for background:

```cpp
"ESC[" + "<color code>" + "m"
```

These codes can be output together in order to change fore- and back-ground colors simultaneously.

## Using the Code

Before you can output the color code, you need to generate the **ESC** sequence. It's probably easiest to do that once and store it for later:

```cpp
:: Sets up the ESC string for use later in this script
:setESC
    for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
      set ESC=%%b
      exit /B 0
    )
    exit /B 0
```

This will set a variable `ESC` with the correct sequence.

A simple example of outputting red text:

```cpp
setlocal enabledelayedexpansion
call :setESC
echo !ESC![91mThis is red text!ESC![0m
```

An example of outputting red text on a white background:

```cpp
setlocal enabledelayedexpansion
call :setESC
echo !ESC![91m!ESC![107mThis is red text on a white background!ESC![0m"
```

This is a little cumbersome so I've created some simple subroutines that provide the means to output text in a more civilised manner.

## Helper Functions

The following helper functions allow you to do stuff like:

```cpp
call :WriteLine "This is red text" "Red"
call :WriteLine "This is red text on a white background" "Red" "White"
```

Much easier.

```cpp
REM  Set to false if you find your environment just doesn't handle colors well
set useColor=true

:: Sets up the ESC string for use later in this script
:setESC
    for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
      set ESC=%%b
      exit /B 0
    )
    exit /B 0

:: Sets the currentColor global for the given foreground/background colors
:: currentColor must be output to the terminal before outputting text in
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

    REM This requires the setContrastForeground subroutine, which is discussed below
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
```

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Windows-Terminal/master/docs/assets/color1.PNG)

## Handling Contrast

Suppose we have defined a set of predefined colors and we want to use them to ensure consistency:

```cpp
set color_primary=Blue
set color_mute=Gray
set color_info=Yellow
set color_success=Green
set color_warn=DarkYellow
set color_error=Red
```

If we output text using these as background colors, we get:

```cpp
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
```

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Windows-Terminal/master/docs/assets/color2.PNG)

Things are a bit murky so let's add one more function that will provide a contrasting foreground on whatever background we choose.

```cpp
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
```

We've already wired this up in the `Write` methods: If the foreground color is set as "`Contrast`", then the foreground will be set as something that has a decent contrast to the given background.

To use, we simply do:

```cpp
call :WriteLine "  Primary colored background" "Contrast" %color_primary%
call :WriteLine "  Mute colored background"    "Contrast" %color_mute%
call :WriteLine "  Info colored background"    "Contrast" %color_info%
call :WriteLine "  Success colored background" "Contrast" %color_success%
call :WriteLine "  Warning colored background" "Contrast" %color_warn%
call :WriteLine "  Error colored background"   "Contrast" %color_error%
```

![](https://raw.githubusercontent.com/ChrisMaunder/How-to-Change-Text-Color-in-a-Windows-Terminal/master/docs/assets/color3.PNG)

## Interesting Points

A challenge in this was outputting text via a CMD shell without a newline. The `<var>echo</var>` command, by default, adds a line feed. To output text in a CMD script without including a line feed, simply use:

```cpp
<NUL set /p ="My string goes here"
```
