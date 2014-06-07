@echo off

rem GENERAL COMPILER SETTINGS
set CC65_HOME=..\..\..\cc65
set PATH=%PATH%;%CC65_HOME%\bin

set RUNTIME=nes.lib

rem COMPILE
cc65.exe -t nes -O -D __NES__ game.c
ca65.exe -t nes crt0.s
ca65.exe -t nes neslib.s
ca65.exe -t nes game.s

rem LINK
ld65.exe -t nes -o ..\game.nes crt0.o game.o neslib.o %RUNTIME%

pause

del *.o
