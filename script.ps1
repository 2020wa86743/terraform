# Download the Chrome installer
$chromeInstaller = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$output = "C:\Windows\Temp\chrome_installer.exe"
Invoke-WebRequest -Uri $chromeInstaller -OutFile $output

# Install Chrome silently
Start-Process -FilePath $output -ArgumentList "/silent /install" -Wait

# Clean up
Remove-Item -Path $output
