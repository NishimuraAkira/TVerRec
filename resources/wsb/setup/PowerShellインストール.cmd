@echo off

echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo WinGet���C���X�g�[�����邽�߂ɕK�v�ȃ\�t�g�E�F�A���C���X�g�[�����܂�...

echo �@WinGet PowerShell module��PSGallery����C���X�g�[�����܂�...
powershell -Command "Install-PackageProvider -Name NuGet -Force | Out-Null"
powershell -Command "Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null"

echo �@Repair-WinGetPackageManager�R�}���h���b�g���g�p����WinGet���g�p�\�ȏ�Ԃɂ��܂�...
powershell -Command "Repair-WinGetPackageManager"

echo �@WinGet�̃C���X�g�[�����������܂����B

echo.
echo Notepad++���C���X�g�[�����܂�...
winget install -e --id Notepad++.Notepad++ --accept-source-agreements --accept-package-agreements --source winget

echo.
echo VLC���C���X�g�[�����܂�...
winget install -e --id VideoLAN.VLC --accept-source-agreements --accept-package-agreements --source winget

echo.
echo Git���C���X�g�[�����܂�...
winget install -e --id Git.Git --accept-source-agreements --accept-package-agreements --source winget

echo.
echo VS Code���C���X�g�[�����܂�...
winget install -e --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements --source winget

echo.
echo PowerShell���C���X�g�[�����܂�...
winget install -e --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements --source winget

echo.
powershell -Command "Add-Type -AssemblyName System.Windows.Forms | Out-Null ; [System.Windows.Forms.MessageBox]::Show('PowerShell�̃C���X�g�[�����������܂����B', 'TVerRec')"

explorer.exe "C:\Users\WDAGUtilityAccount\Desktop\TVerRec\win"
