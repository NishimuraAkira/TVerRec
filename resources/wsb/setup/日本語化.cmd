@echo off
powershell Set-WinUserLanguageList -Force ja-JP
powershell Set-WinSystemLocale -SystemLocale ja-JP
powershell Set-WinUILanguageOverride -Language ja-JP
powershell Set-WinHomeLocation 122
powershell -Command "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('���{�ꉻ����������ɂ͍ċN�����K�v�ł��BOK�������Ǝ����I��Windows�T���h�{�b�N�X���ċN�����܂��B', 'TVerRec')"
powershell Restart-Computer
