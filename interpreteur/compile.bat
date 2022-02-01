setlocal enabledelayedexpansion
@echo off
set SRC=src\compiler\test.adb
set COMMANDE=""

set argC = 0


for %%x in (%*) do Set /A argC+=1

if "%argC%" == 1 (
  set SRC="%1"
  echo "OUI"
)

md dist
cd src/

for /F %%f in ('dir /a:d /s /b /o:n') do (
  set "COMMANDE=!COMMANDE! -I%%f"
)

cd ..\dist

gnatmake ..\%SRC% %COMMANDE%

cd ..