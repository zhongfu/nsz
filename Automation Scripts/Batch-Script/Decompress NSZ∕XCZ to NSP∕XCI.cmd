@ECHO OFF & CHCP 65001 1>NUL & COLOR 07
TITLE Decompress NSZ/XCZ to NSP/XCI

REM nsz.exe file path.
SET "nszFilePath=%~dp0nsz.exe"

REM Source directory path where to search for NSZ/XCZ files.
SET "SrcDirectoryPath=C:\Nintendo Switch dumps"

REM Destination directory path where to save decompressed NSP/XCI files.
SET "DstDirectoryPath=%SrcDirectoryPath%"

REM 'True' to enable recursive NSZ/XCZ file search on source directory, 'False' to disable it.
SET "EnableRecursiveSearch=False"

REM Additional nsz.exe parameters.
SET "AdditionalParameters=--alwaysParseCnmt --undupe-rename --titlekeys --quick-verify"

:WELCOME_SCREEN
ECHO:╔════════════════════════════════════════════════════════════════╗
ECHO:║ TITLE   │ Decompress NSZ/XCZ to NSP/XCI Script                 ║
ECHO:║_________│______________________________________________________║
ECHO:║         │ Automates the decompression of Nintendo Switch       ║
ECHO:║ PURPOSE │ NSZ/XCZ dumps back into NSP/XCI format respectively. ║
ECHO:║_________│______________________________________________________║
ECHO:║ VERSION │ ElektroStudios - Ver. 1.2 'keep it simple'           ║
ECHO:╚════════════════════════════════════════════════════════════════╝
ECHO+
ECHO:IMPORTANT: Before proceeding, open this script file in Notepad to adjust the following script settings as needed.
ECHO+
ECHO: ○ nsz.exe file path:
ECHO:   %nszFilePath%
ECHO+
ECHO: ○ Source directory path where to search for NSZ/XCZ files:
ECHO:   %SrcDirectoryPath%
ECHO+
ECHO: ○ Destination directory path where to save decompressed NSP/XCI files:
ECHO:   %DstDirectoryPath%
ECHO+
ECHO: ○ Enable recursive NSZ/XCZ file search on source directory:
ECHO:   %EnableRecursiveSearch%
ECHO+
ECHO: ○ Additional nsz.exe parameters:
ECHO:   %AdditionalParameters%
ECHO+
PAUSE
CLS

:PRIMARY_CHECKS
REM Ensure nsz.exe file exists.
IF NOT EXIST "%nszFilePath%" (
	CALL :PRINT_ERROR_AND_EXIT nsz.exe file does not exists: "%nszFilePath%"
)
REM Ensure the source directory exists.
IF NOT EXIST "%SrcDirectoryPath%" (
	CALL :PRINT_ERROR_AND_EXIT Source directory does not exists: "%SrcDirectoryPath%"
)
REM Ensure the output directory can be created.
MKDIR "%DstDirectoryPath%" 1>NUL 2>&1 || (
	IF NOT EXIST "%DstDirectoryPath%" (
		CALL :PRINT_ERROR_AND_EXIT Output directory can't be created: "%DstDirectoryPath%"
	)
)

:NSZ_WORK
REM FOR-loop logic.
IF /I "%EnableRecursiveSearch%" EQU "True" (
	SET "Params=/R "%SrcDirectoryPath%" %%# IN ("*.nsz" "*.xcz")"
) ELSE (
	SET "Params=%%# IN ("%SrcDirectoryPath%\*.nsz" "%SrcDirectoryPath%\*.xcz")"
)
FOR %Params% DO (
	TITLE nsz "%%~nx#"
	ECHO:Decompressing "%%~f#"...
	ECHO+
	("%nszFilePath%" -D "%%~f#" --output "%DstDirectoryPath%" %AdditionalParameters%) || (
		CALL :PRINT_ERROR_AND_EXIT nsz failed to decompress file: "%%~f#"
	)
)

:GOODBYE_SCREEN
COLOR 0A
ECHO+
ECHO:Operation Completed!
ECHO+
PAUSE & EXIT 0

:PRINT_ERROR_AND_EXIT
COLOR 0C
ECHO+
ECHO:ERROR OCCURRED: %*
ECHO+
PAUSE & EXIT 1