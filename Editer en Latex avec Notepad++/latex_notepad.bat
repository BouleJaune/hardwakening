@echo off
if "%~x1"==".tex" goto pdflatex
   echo "%~f1" is not a recognized type, extension is "%~x1"
   pause
   exit /b

:pdflatex
   cd /d "%~dp1"
   IF NOT EXIST "%~dp1\build" mkdir build

   start "inverseSearch" /min "%PROGRAMFILES%\SumatraPDF\SumatraPDF.exe" -inverse-search "\"%PROGRAMFILES%\Notepad++\notepad++.exe\" -n%%l \"%%f\"" -reuse-instance

   pdflatex.exe -draftmode -interaction=batchmode -aux-directory="%~pd1\build" -output-directory="%~pd1\build" "%~pdn1"
   echo. && echo.
   bibtex.exe "%~dp1\build\%~n1.aux"
   echo. && echo.
   pdflatex.exe -draftmode -interaction=batchmode -aux-directory="%~pd1\build" -output-directory="%~pd1\build" "%~pdn1"
   echo. && echo.
   pdflatex.exe -interaction=batchmode -synctex=-1 -aux-directory="%~pd1\build" -output-directory="%~pd1\build" -quiet "%~pdn1"
   echo. && echo.

   type "%~dp1\build\%~n1.log" | findstr Warning:

   start "openPDF" "%PROGRAMFILES%\SumatraPDF\SumatraPDF.exe"  "%~dp1\build\%~n1.pdf" -reuse-instance

   echo SUMATRA>"%~dp1\build\cmcdde.tmp"
   echo control>>"%~dp1\build\cmcdde.tmp"
   echo [ForwardSearch("%~dp1\build\%~n1.pdf", "%~f1", %2, 0, 0, 0)]>>"%~dp1\build\cmcdde.tmp"

   "%PROGRAMFILES%\cmcdde.exe" @"%~dp1\build\cmcdde.tmp"

   del "%~dp1\build\cmcdde.tmp"
   exit /b