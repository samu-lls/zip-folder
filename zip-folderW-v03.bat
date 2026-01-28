@echo off
REM ========================================================
REM Zip Folder - Manual Soft Delete Week Script by @samu.lls
REM ========================================================

set day_folder={C:\Pasta-alvo}\day
set week_folder={C:\Pasta-destino}\week
set sevenzip={C:\Program Files\7-Zip\7z.exe}

REM ================================================
REM Não Modifique Abaixo Daqui
REM ================================================

if not exist "%week_folder%" mkdir "%week_folder%"
dir /b "%day_folder%\*.zip" >nul 2>&1
if %errorlevel% neq 0 (
    echo Nenhum backup diario encontrado para compactar.
    pause
    exit /b
)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set ano_atual=%datetime:~0,4%
set mes_atual=%datetime:~4,2%
set dia_atual=%datetime:~6,2%
set /a dias_total=%ano_atual%*365 + %mes_atual%*30 + %dia_atual% - 7
set /a ano_passado=%dias_total%/365
set /a resto=%dias_total% %% 365
set /a mes_passado=%resto%/30
set /a dia_passado=%resto% %% 30
if %mes_passado% lss 10 set mes_passado=0%mes_passado%
if %dia_passado% lss 10 set dia_passado=0%dia_passado%
set destination=%week_folder%\Semana_%dia_passado%_%mes_passado%_%ano_passado%.zip

echo Compactando backups semanais...
echo Semana iniciada em: %dia_passado%/%mes_passado%/%ano_passado%
echo Origem: %day_folder%
echo Destino: %destination%
"%sevenzip%" a -tzip "%destination%" "%day_folder%\*.zip"
if %errorlevel% equ 0 (
    echo Compactacao semanal concluida com sucesso!
    echo Excluindo backups diarios...
    del /q "%day_folder%\*.zip"
    echo Backups diarios excluidos!
    echo.
    echo Ciclo semanal finalizado. Pronto para nova semana!
) else (
    echo Erro ao compactar! Backups diarios NAO foram excluidos por seguranca.
)
pause