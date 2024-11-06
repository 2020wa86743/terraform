[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
# Define the URL for the 7-Zip installer (64-bit version)
$sevenZipUrl = "https://www.7-zip.org/a/7z1900-x64.exe"  # Update the URL if a newer version is available
$installerPath = "$env:TEMP\7z1900-x64.exe"

# Function to download the installer
function Download-Installer {
    try {
        Write-Output "Downloading 7-Zip installer..."
        Invoke-WebRequest -Uri $sevenZipUrl -OutFile $installerPath -ErrorAction Stop
        Write-Output "Download complete."
    } catch {
        Write-Error "Failed to download installer: $_"
        exit 1
    }
}

# Function to install 7-Zip
function Install-7Zip {
    try {
        Write-Output "Installing 7-Zip..."
        Start-Process -FilePath $installerPath -ArgumentList "/S" -NoNewWindow -Wait -ErrorAction Stop
        Write-Output "7-Zip installation complete."
    } catch {
        Write-Error "Failed to install 7-Zip: $_"
        exit 1
    }
}

# Function to verify installation
function Verify-Installation {
    if (Test-Path "C:\Program Files\7-Zip\7zFM.exe") {
        Write-Output "7-Zip has been installed successfully."
    } else {
        Write-Error "7-Zip installation failed."
        exit 1
    }
}

# Function to clean up installer
function Clean-Up {
    try {
        Write-Output "Cleaning up..."
        Remove-Item -Path $installerPath -Force -ErrorAction Stop
        Write-Output "Cleanup complete."
    } catch {
        Write-Error "Failed to clean up installer: $_"
        exit 1
    }
}

# Function to install chrome
function Install-Chrome {
    try {
        $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; 
        (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
    } catch {
        Write-Error "Failed to install Chrome"
        exit 1
    }
}


# Execute functions
Download-Installer
Install-7Zip
Verify-Installation
Clean-Up
Install-Chrome
