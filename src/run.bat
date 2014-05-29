@echo off

rem NESTOPIA PATH
if [%1]==[debug] goto debug
if [%1]==[dbg] goto debug

:nestopia
set EMULATOR=D:\Inne\NESDEV\nestopia\nestopia.exe
goto launch

:debug
set EMULATOR=D:\Inne\NESDEV\fceuxdsp\fceuxdsp.exe

:launch
%EMULATOR% ..\game.nes
