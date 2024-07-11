################################################################################
# Repository: tommyvange/NetFx3-Management-Scripts
# File: uninstall.ps1
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
    [switch] $Logging
)

# Path to configuration file
$configFilePath = "$PSScriptRoot\config.json"

# Initialize configuration variable
$config = $null

# Check if configuration file exists and load it
if (Test-Path $configFilePath) {
    $config = Get-Content -Path $configFilePath | ConvertFrom-Json
}

# Use parameters from the command line or fall back to config file values
if (-not $Logging -and $config.Logging -ne $null) { $Logging = $config.Logging }

# Determine log file path
$logFilePath = "$env:TEMP\uninstallation_log_NetFx3.txt"

# Start transcript logging if enabled
if ($Logging) {
    Start-Transcript -Path $logFilePath
}

Function Uninstall-NetFx3 {
    try {
        Disable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -Remove -NoRestart
        if ($?) {
            Write-Output "Successfully uninstalled .NET Framework 3.5."
            exit 0
        } else {
            Write-Error "Failed to uninstall .NET Framework 3.5."
            exit 1
        }
    } catch {
        Write-Error "An unexpected error occurred: $_"
        exit 1
    }
}

Uninstall-NetFx3

# Stop transcript logging if enabled
if ($Logging) {
    Stop-Transcript
}
