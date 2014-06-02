@echo off
set PATH=%PATH%;D:\Inne\NESDEV\cc65\bin

setlocal ENABLEDELAYEDEXPANSION
set vidx=0

for /F "tokens=*" %%A in (libs.txt) do (
	SET /A vidx=!vidx! + 1
	ar65 x nes.lib %%A
	echo Extracted module no'!vidx! = %%A
)

pause
