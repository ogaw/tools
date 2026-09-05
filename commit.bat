@echo off
setlocal

cd /d "%~dp0"

echo.
echo == Git status ==
git status --short
if errorlevel 1 goto :error

echo.
set /p COMMIT_MSG=Commit message [Update files]: 
if "%COMMIT_MSG%"=="" set "COMMIT_MSG=Update files"

echo.
echo == Staging changes ==
git add .
if errorlevel 1 goto :error

echo.
echo == Staged changes ==
git diff --cached --quiet
if errorlevel 1 (
  git diff --cached --stat
  echo.
  choice /c YN /m "Commit and push these changes?"
  if errorlevel 2 goto :cancel

  echo.
  echo == Commit ==
  git commit -m "%COMMIT_MSG%"
  if errorlevel 1 goto :error
) else (
  echo No staged changes. Skipping commit.
)

echo.
echo == Push ==
git push origin main
if errorlevel 1 goto :error

echo.
echo Done.
pause
exit /b 0

:error
echo.
echo Failed. Check the message above.
pause
exit /b 1

:cancel
echo.
echo Canceled. Staged changes were left in place.
pause
exit /b 0
