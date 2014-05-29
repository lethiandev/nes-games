@echo off

rem GENERAL COMPILER SETTINGS
set CC65_HOME=..\..\..\cc65
set PATH=%PATH%;%CC65_HOME%\bin

set RUNTIME=rt\copydata.o rt\zerobss.o rt\zeropage.o rt\pusha.o rt\pushax.o rt\popa.o rt\incsp3.o rt\incsp1.o rt\incsp2.o rt\ldaxsp.o rt\addysp.o rt\incax1.o rt\staxsp.o rt\decaxy.o

rem COMPILE
cc65.exe -t nes -O -D __NES__ game.c
ca65.exe -t nes crt0.s
ca65.exe -t nes neslib.s
ca65.exe -t nes game.s

rem LINK
ld65.exe -t nes -o ..\game.nes crt0.o game.o neslib.o %RUNTIME%

pause

del *.o
