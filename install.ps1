################################################################################
# Repository: tommyvange/NetFx3-Management-Scripts
# File: install.ps1
# Developer: Tommy Vange Rød
# License: GPL 3.0 License
#
# This file is part of "NetFx3-Management-Scripts".
#
# "NetFx3-Management-Scripts" is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/gpl-3.0.html#license-text>.
################################################################################

param (
    [switch] $Online,
    [switch] $Offline,
    [switch] $Logging,
    [switch] $NoRestart,
    [string] $SxsPath
)

# Path to configuration file
$configFilePath = "$PSScriptRoot\config.json"

# Initialize configuration variable
$config = $null

# Check if configuration file exists and load it
if (Test-Path $configFilePath) {
    $config = Get-Content -Path $configFilePath | ConvertFrom-Json
}

# Detect Windows version and set the default SxsPath accordingly
$osCaption = (Get-WmiObject Win32_OperatingSystem).Caption
if ($osCaption -Match "Windows 10") {
    $defaultSxsPath = Join-Path -Path $PSScriptRoot -ChildPath "source\w10\sxs"
} elseif ($osCaption -Match "Windows 11") {
    $defaultSxsPath = Join-Path -Path $PSScriptRoot -ChildPath "source\w11\sxs"
} else {
    if ($Offline) {
        Write-Error "Unsupported Windows version for offline installation: $osCaption"
        exit 1
    } else {
        Write-Warning "Unsupported Windows version: $osCaption. Skipping offline installation and proceeding with online installation."
        $Online = $true
        $Offline = $false
    }
}

# Use parameters from the command line or fall back to config file values
if (-not $Online -and $config.Online -ne $null) { $Online = $config.Online }
if (-not $Offline -and $config.Offline -ne $null) { $Offline = $config.Offline }
if (-not $Logging -and $config.Logging -ne $null) { $Logging = $config.Logging }
if (-not $SxsPath) { $SxsPath = $defaultSxsPath }

# Ensure the SxsPath is properly formatted
$SxsPath = $SxsPath.TrimEnd('\')

# Determine log file path
$logFilePath = "$env:TEMP\installation_log_NetFx3.txt"

# Start transcript logging if enabled
if ($Logging) {
    Start-Transcript -Path $logFilePath
}

Function Install-NetFx3 {
    try {
        if ($Online) {
            Write-Output "Using online installation."
            Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -All -NoRestart -ErrorAction Stop
            Write-Output "Successfully installed .NET Framework 3.5 using online source."
            exit 0
        } elseif ($Offline) {
            Write-Output "Using offline installation."
            if (Test-Path "$SxsPath\Microsoft-Windows-NetFx3-OnDemand-Package*.cab") {
                $cabFile = Get-ChildItem -Path $SxsPath -Filter 'Microsoft-Windows-NetFx3-OnDemand-Package*.cab' | Select-Object -First 1
                if ($cabFile) {
                    $cabPath = $cabFile.FullName
                    Write-Output "Using offline source file: $cabPath"
                    Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -All -Source $SxsPath -NoRestart -LimitAccess -ErrorAction Stop
                    Write-Output "Successfully installed .NET Framework 3.5 using offline source."
                    exit 0
                } else {
                    Write-Error "CAB file not found in the specified path."
                    exit 1
                }
            } else {
                Write-Error "Offline source not found at $SxsPath."
                exit 1
            }
        } else {
            # Try offline first
            if (Test-Path "$SxsPath\Microsoft-Windows-NetFx3-OnDemand-Package*.cab") {
                Write-Output "Found offline source at $SxsPath"
                try {
                    $cabFile = Get-ChildItem -Path $SxsPath -Filter 'Microsoft-Windows-NetFx3-OnDemand-Package*.cab' | Select-Object -First 1
                    if ($cabFile) {
                        $cabPath = $cabFile.FullName
                        Write-Output "Using offline source file: $cabPath"
                        Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -All -Source $SxsPath -NoRestart -LimitAccess -ErrorAction Stop
                        Write-Output "Successfully installed .NET Framework 3.5 using offline source."
                        exit 0
                    } else {
                        Write-Warning "CAB file not found in the specified path. Falling back to online installation."
                    }
                } catch {
                    Write-Warning "Failed to install .NET Framework 3.5 using offline source. Error: $_"
                    Write-Warning "Falling back to online installation."
                }
            } else {
                Write-Warning "Offline source not found at $SxsPath. Falling back to online installation."
            }

            # Attempt online installation if offline fails or not found
            try {
                Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -All -NoRestart -ErrorAction Stop
                Write-Output "Successfully installed .NET Framework 3.5 using online source."
                exit 0
            } catch {
                Write-Error "Failed to install .NET Framework 3.5 using online source. Error: $_"
                exit 1
            }
        }
    } catch {
        Write-Error "An unexpected error occurred: $_"
        exit 1
    }
}

Install-NetFx3

# Stop transcript logging if enabled
if ($Logging) {
    Stop-Transcript
}
