@echo off
REM ========================================================
REM Zip Folder - Manual Soft Delete Day Script by @samu.lls
REM ========================================================

set source={C:\Pasta-alvo}
set destination_folder={C:\Pasta-destino}
set sevenzip={C:\Program Files\7-Zip\7z.exe}

REM ================================================
REM Não Modifique Abaixo Daqui
REM ================================================

if not exist "%destination_folder%" mkdir "%destination_folder%"
for /f "skip=1" %%a in ('wmic path win32_localtime get dayofweek') do (
    set daynum=%%a
    goto :continue
)
:continue
if "%daynum%"=="0" set dayname=Domingo
if "%daynum%"=="1" set dayname=Segunda
if "%daynum%"=="2" set dayname=Terca
if "%daynum%"=="3" set dayname=Quarta
if "%daynum%"=="4" set dayname=Quinta
if "%daynum%"=="5" set dayname=Sexta
if "%daynum%"=="6" set dayname=Sabado
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set dia=%datetime:~6,2%
set mes=%datetime:~4,2%
set ano=%datetime:~0,4%
set hora=%datetime:~8,2%
set minuto=%datetime:~10,2%
set segundo=%datetime:~12,2%
set destination=%destination_folder%\%dayname%_%dia%_%mes%_%ano%_%hora%_%minuto%_%segundo%.zip
echo Compactando com 7-Zip...
echo Origem: %source%
echo Destino: %destination%
"%sevenzip%" a -tzip "%destination%" "%source%"
if %errorlevel% equ 0 (
    echo Concluido com sucesso!
) else (
    echo Erro ao compactar!
)
pause