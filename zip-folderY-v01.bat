@echo off
REM ========================================================
REM Zip Folder - Manual Soft Delete Year Script by @samu.lls
REM ========================================================

set month_folder={C:\Pasta-alvo}\month
set year_folder={C:\Pasta-destino}\year
set sevenzip={C:\Program Files\7-Zip\7z.exe}

REM ================================================
REM Não Modifique Abaixo Daqui
REM ================================================

if not exist "%year_folder%" mkdir "%year_folder%"
dir /b "%month_folder%\*.zip" >nul 2>&1
if %errorlevel% neq 0 (
    echo Nenhum backup mensal encontrado para compactar.
    pause
    exit /b
)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set ano_atual=%datetime:~0,4%

set /a ano_anterior=%ano_atual% - 1
set destination=%year_folder%\Ano_%ano_anterior%.zip

echo Compactando backups anuais...
echo Ano: %ano_anterior%
echo Origem: %month_folder%
echo Destino: %destination%
"%sevenzip%" a -tzip "%destination%" "%month_folder%\*.zip"
if %errorlevel% equ 0 (
    echo Compactacao anual concluida com sucesso!
    echo Excluindo backups mensais...
    del /q "%month_folder%\*.zip"
    echo Backups mensais excluidos!
    echo.
    echo Ciclo anual finalizado. Pronto para novo ano!
) else (
    echo Erro ao compactar! Backups mensais NAO foram excluidos por seguranca.
)
pause