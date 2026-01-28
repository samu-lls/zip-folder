@echo off
REM ==========================================================
REM Zip Folder - Manual Soft Delete Month Script by @samu.lls
REM ==========================================================

set week_folder={C:\Pasta-alvo}\week
set month_folder={C:\Pasta-destino}\month
set sevenzip={C:\Program Files\7-Zip\7z.exe}

REM ================================================
REM Não Modifique Abaixo Daqui
REM ================================================

if not exist "%month_folder%" mkdir "%month_folder%"
dir /b "%week_folder%\*.zip" >nul 2>&1
if %errorlevel% neq 0 (
    echo Nenhum backup semanal encontrado para compactar.
    pause
    exit /b
)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set ano_atual=%datetime:~0,4%
set mes_atual=%datetime:~4,2%

set /a mes_anterior=%mes_atual% - 1
set ano_anterior=%ano_atual%

if %mes_anterior% lss 1 (
    set mes_anterior=12
    set /a ano_anterior=%ano_atual% - 1
)

if %mes_anterior% lss 10 set mes_anterior=0%mes_anterior%

if "%mes_anterior%"=="01" set nome_mes=Janeiro
if "%mes_anterior%"=="02" set nome_mes=Fevereiro
if "%mes_anterior%"=="03" set nome_mes=Marco
if "%mes_anterior%"=="04" set nome_mes=Abril
if "%mes_anterior%"=="05" set nome_mes=Maio
if "%mes_anterior%"=="06" set nome_mes=Junho
if "%mes_anterior%"=="07" set nome_mes=Julho
if "%mes_anterior%"=="08" set nome_mes=Agosto
if "%mes_anterior%"=="09" set nome_mes=Setembro
if "%mes_anterior%"=="10" set nome_mes=Outubro
if "%mes_anterior%"=="11" set nome_mes=Novembro
if "%mes_anterior%"=="12" set nome_mes=Dezembro

set destination=%month_folder%\Mes_%nome_mes%_%ano_anterior%.zip

echo Compactando backups mensais...
echo Mes: %nome_mes%/%ano_anterior%
echo Origem: %week_folder%
echo Destino: %destination%
"%sevenzip%" a -tzip "%destination%" "%week_folder%\*.zip"
if %errorlevel% equ 0 (
    echo Compactacao mensal concluida com sucesso!
    echo Excluindo backups semanais...
    del /q "%week_folder%\*.zip"
    echo Backups semanais excluidos!
    echo.
    echo Ciclo mensal finalizado. Pronto para novo mes!
) else (
    echo Erro ao compactar! Backups semanais NAO foram excluidos por seguranca.
)
pause