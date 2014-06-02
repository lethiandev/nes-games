@echo off

rem NESTOPIA PATH
if [%1]==[debug] goto debug
if [%1]==[dbg] goto debug
goto debug

:nestopia
set EMULATOR=..\..\..\nestopia\nestopia.exe
goto launch

:debug
set EMULATOR=..\..\..\fceuxdsp\fceuxdsp.exe

:launch
%EMULATOR% ..\game.nes
