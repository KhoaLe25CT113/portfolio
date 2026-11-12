@echo off
chcp 65001 >nul
echo ======================================================
echo    CAP NHAT ANH CHAN DUNG CHO PORTFOLIO & CV
echo ======================================================
powershell -ExecutionPolicy Bypass -File "%~dp0update-avatar.ps1"
echo.
pause
