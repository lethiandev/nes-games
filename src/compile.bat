@echo off

rem GENERAL COMPILER SETTINGS
set CC65_HOME=..\..\..\cc65
set PATH=%PATH%;%CC65_HOME%\bin

set RUNTIME=rt\copydata.o rt\zerobss.o rt\zeropage.o rt\pusha.o rt\pushax.o rt\popa.o rt\incaxy.o rt\incsp1.o rt\incsp2.o rt\incsp3.o rt\ldaxsp.o rt\addysp.o rt\incax1.o rt\incsp4.o rt\staxsp.o rt\decaxy.o rt\shl.o rt\aslax1.o rt\aslax2.o rt\aslax3.o rt\aslax4.o

rem COMPILE
cc65.exe -t nes -O -D __NES__ game.c
ca65.exe -t nes crt0.s
ca65.exe -t nes neslib.s
ca65.exe -t nes game.s

rem LINK
ld65.exe -t nes -o ..\game.nes crt0.o game.o neslib.o %RUNTIME%

pause

del *.o
