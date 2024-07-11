################################################################################
# Repository: tommyvange/NetFx3-Management-Scripts
# File: check.ps1
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

Function Check-NetFx3 {
    try {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName 'NetFx3'

        if ($feature.State -eq 'Enabled') {
            Write-Output "Detected"
            exit 0
        } else {
            Write-Output "NotDetected"
            exit 1
        }
    } catch {
        Write-Error "An error occurred: $_"
        exit 1
    }
}

Check-NetFx3
