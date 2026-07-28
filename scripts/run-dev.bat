@echo off
setlocal

title SynapseLink - Dev Install

echo.
echo ========================================
echo  SynapseLink - Build + Install
echo ========================================
echo.

cd /d "%~dp0.."

echo.
echo Gerando main.js...
echo.

call npm run build

if errorlevel 1 (
    echo.
    echo ERRO: Falha no build.
    pause
    exit /b 1
)

echo.
echo Build concluido.
echo.

set /p "VAULT_PATH=Informe o caminho do vault do Obsidian: "

if "%VAULT_PATH%"=="" (
    echo Caminho vazio.
    pause
    exit /b 1
)

powershell.exe ^
-NoProfile ^
-ExecutionPolicy Bypass ^
-File "scripts\install-dev.ps1" ^
-VaultPath "%VAULT_PATH%"

pause
endlocal