if not exist "C:\Windows\Temp\7z1900-x64.msi" (
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z1900-x64.msi', 'C:\Windows\Temp\7z1900-x64.msi')" <NUL
)
if not exist "C:\Windows\Temp\7z1900-x64.msi" (
    powershell -Command "Start-Sleep 5 ; (New-Object System.Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z1900-x64.msi', 'C:\Windows\Temp\7z1900-x64.msi')" <NUL
)
msiexec /qb /i C:\Windows\Temp\7z1900-x64.msi

if "%PACKER_BUILDER_TYPE%" equ "virtualbox-iso" goto :virtualbox
goto :done

:virtualbox

if exist "C:\Users\vagrant\VBoxGuestAdditions.iso" (
    move /Y C:\Users\vagrant\VBoxGuestAdditions.iso C:\Windows\Temp
)

if not exist "C:\Windows\Temp\VBoxGuestAdditions.iso" (
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://download.virtualbox.org/virtualbox/6.0.8/VBoxGuestAdditions_6.0.8.iso', 'C:\Windows\Temp\VBoxGuestAdditions.iso')" <NUL
)

cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\VBoxGuestAdditions.iso -oC:\Windows\Temp\virtualbox"
cmd /c for %%i in (C:\Windows\Temp\virtualbox\cert\vbox*.cer) do C:\Windows\Temp\virtualbox\cert\VBoxCertUtil add-trusted-publisher %%i --root %%i
cmd /c C:\Windows\Temp\virtualbox\VBoxWindowsAdditions.exe /S
rd /S /Q "C:\Windows\Temp\virtualbox"
goto :done

:done
msiexec /qb /x C:\Windows\Temp\7z1900-x64.msi
