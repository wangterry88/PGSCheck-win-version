@echo off
cd /d %~dp0
start /wait .\Step1.bat & start .\Step2.bat & exit