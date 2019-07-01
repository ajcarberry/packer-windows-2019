# Source : https://github.com/luciusbono/Packer-Windows10/blob/master/install-guest-tools.ps1
# Set the path of the VMWare Tools ISO - this is set in the Packer JSON file

$isopath = "C:\Windows\Temp\windows.iso"

# Mount the .iso, then build the path to the installer by getting the Driveletter attribute from Get-DiskImage piped into Get-Volume and adding a :\setup.exe
# A separate variable is used for the parameters. There are cleaner ways of doing this. I chose the /qr MSI Installer flag because I personally hate silent installers
# Even though our build is headless. 

Write-Output "***** Mounting disk image at $isopath"
Mount-DiskImage -ImagePath $isopath

function virtualbox {

$certdir = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\cert\')
$VBoxCertUtil = ($certdir + 'VBoxCertUtil.exe')

# Added support for VirtualBox 4.4 and above by doing this silly little trick.
# We look for the presence of VBoxCertUtil.exe and use that as the deciding factor for what method to use.
# The better way to do this would be to parse the Virtualbox version file that Packer can upload, but this was quick.

if (Test-Path ($VBoxCertUtil)) {
        Write-Output "Using newer (4.4 and above) certificate import method"
	Get-ChildItem $certdir *.cer | ForEach-Object { & $VBoxCertUtil add-trusted-publisher $_.FullName --root $_.FullName}
}

else {
        Write-Output "Using older (4.3 and below) certificate import method"
	$certpath = ($certdir + 'oracle-vbox.cer')
	certutil -addstore -f "TrustedPublisher" $certpath
}

$exe = ((Get-DiskImage -ImagePath $isopath | Get-Volume).Driveletter + ':\VBoxWindowsAdditions.exe')
$parameters = '/S'

Start-Process $exe $parameters -Wait

}

virtualbox

#Time to clean up - dismount the image and delete the original ISO

Write-Output "Dismounting disk image $isopath"
Dismount-DiskImage -ImagePath $isopath
Write-Output "Deleting $isopath"
Remove-Item $isopath