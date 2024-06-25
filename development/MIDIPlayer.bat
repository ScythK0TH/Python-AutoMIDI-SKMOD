@echo off
setlocal
rem -- Options (Feel free to modify) -------

set INITIAL_MEMORY=2G
set MAX_MEMORY=2G
set JVM_ARGS=-XX:+UseG1GC
set UMP_OPTIONS=
set PAUSE_AFTER_EXIT=false
set CRASH_ON_OUT_OF_MEMORY=true

rem -- End of options ----------------------



rem -- Special flags -----------------------

rem "MIDIPlayer.bat --show-oom-message" runs on OOM
if "%~1"=="--show-oom-message" (
  echo.
  echo -=[!]================== UMP Out of Memory ==================[!]=-
  echo      UMP has ran out of memory and needs to stop!
  echo      Increase memory allocation or avoid loading big MIDIs
  echo.
  echo      See:
  echo      https://pipiraworld.web.fc2.com/ump/manual/#Memory
  echo -=[!]=======================================================[!]=-
  echo.
  exit /b
)

rem -- Java check --------------------------

cd /d "%~dp0"
where java >nul 2>&1 || (
  echo.
  echo -=[!]================== Java Not Found ===================[!]=-
  echo      Install Java to run UMP!
  echo.
  echo      See:
  echo      https://java.com/download/manual.jsp
  echo      https://pipiraworld.web.fc2.com/ump/manual/#Quick-Start
  echo -=[!]=====================================================[!]=-
  echo.
  pause
  exit /b
)

rem -- UMP ---------------------------------

if "%CRASH_ON_OUT_OF_MEMORY%"=="true" (
  set JVM_ARGS=%JVM_ARGS% -XX:+ExitOnOutOfMemoryError -XX:OnOutOfMemoryError="cmd /c \"%~0\" --show-oom-message"
)

echo UMP Launcher 1.7r1
echo Starting UMP!
echo   Initial Memory: %INITIAL_MEMORY%
echo   Max Memory:     %MAX_MEMORY%
echo Close this window to terminate UMP if you can't close UMP in normal way.
echo.
echo -- Begin JVM/UMP Log -----------
java -Xms%INITIAL_MEMORY% -Xmx%MAX_MEMORY% %JVM_ARGS% -jar MIDIPlayer.jar %UMP_OPTIONS% %*
set UMP_EXITCODE=%ERRORLEVEL%
echo -- End JVM/UMP Log -------------

echo Exitcode: %UMP_EXITCODE%
if not "%UMP_EXITCODE%"=="0" (
  echo.
  echo UMP crash? Look log carefully to find clues! ^(seriously, please do read the log, it's meant to be read^)
  echo.
  pause
) else if "%PAUSE_AFTER_EXIT%"=="true" (
  pause
)
exit /b

rem UMP 1.7 launcher rev 1
rem © 2024 PipiraMine
