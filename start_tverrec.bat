@echo off
rem ###################################################################################
rem #  tverrec : TVer�r�f�I�_�E�����[�_
rem #
rem #		�ꊇ�_�E�����[�h�����J�n�X�N���v�g
rem #
rem #	Copyright (c) 2021 dongaba
rem #
rem #	Licensed under the Apache License, Version 2.0 (the "License");
rem #	you may not use this file except in compliance with the License.
rem #	You may obtain a copy of the License at
rem #
rem #		http://www.apache.org/licenses/LICENSE-2.0
rem #
rem #	Unless required by applicable law or agreed to in writing, software
rem #	distributed under the License is distributed on an "AS IS" BASIS,
rem #	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem #	See the License for the specific language governing permissions and
rem #	limitations under the License.
rem #
rem ###################################################################################


setlocal enabledelayedexpansion
cd %~dp0

for /f %%i in ('hostname') do set HostName=%%i
set PIDFile=%HostName%-pid.txt
set sleepTime=60

powershell "Get-WmiObject win32_process -filter processid=$pid | ForEach-Object{$_.parentprocessid;}" > %PIDFile%

:Loop

	goto Downloader
	echo %sleepTime%�b�ҋ@���܂�
	timeout /T %sleepTime% /nobreak > nul

	goto ProcessChecker
	goto Validator
rem	goto Mover
rem	goto Deleter

	echo %sleepTime%�b�ҋ@���܂�
	timeout /T %sleepTime% /nobreak > nul
	goto Loop

:End
	del %PIDFile%
	pause


:Downloader
	title TVerRec Bulk Downloader
	powershell -NoProfile -ExecutionPolicy Unrestricted .\src\tverrec_bulk.ps1


:ProcessChecker
rem chromedriver�̃]���r���c���Ă�����I��
taskkill /F /T /IM chromedriver.exe
rem ffmpeg�v���Z�X�`�F�b�N
tasklist | find "ffmpeg.exe" > NUL
if %ERRORLEVEL% == 0 (
	echo �_�E�����[�h���ł��B
	tasklist /fi "Imagename eq ffmpeg.exe"
	echo %sleepTime%�b�ҋ@���܂�
	timeout /T %sleepTime% /nobreak > nul
	goto ProcessChecker
)

:Validator
	title TVerRec Video File Validator
	powershell -NoProfile -ExecutionPolicy Unrestricted .\src\validate_video.ps1
	powershell -NoProfile -ExecutionPolicy Unrestricted .\src\validate_video.ps1

:Mover
	title TVerRec Video File Mover
	powershell -NoProfile -ExecutionPolicy Unrestricted .\src\move_video.ps1

:Deleter
	title TVerRec Video File Deleter
	powershell -NoProfile -ExecutionPolicy Unrestricted .\src\delete_ignored.ps1
