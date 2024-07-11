
# .NET 3.5 Framework (NetFx3) Management Scripts

These scripts are designed to install and uninstall .NET Framework 3.5 on Windows machines. They can read parameters from the command line, a configuration file (`config.json`), or use default values. If any required parameter is missing and cannot be resolved, the scripts will fail with an appropriate error message.

This repository is licensed under the **[GNU General Public License v3.0 (GPLv3)](LICENSE)**.

Developed by **[Tommy Vange Rød](https://github.com/tommyvange)**.

## Notice

The contents of the SXS folders inside the `source` folder belong to Microsoft Corporation, who is the copyright and rights holder of these files. These files are necessary for the offline installation of .NET Framework 3.5 on Windows 10 and Windows 11 systems.

## Configuration

The scripts use a configuration file (`config.json`) to store default values for the .NET Framework 3.5 settings.

### Example Configuration File
 
```json
{
    "Online": false,
    "Offline": false,
    "Logging": false
}
```


## Parameters

-   [Optional] `Online`: Use only online installation.
-   [Optional] `Offline`: Use only offline installation.
-   [Optional] `Logging`: Enables transcript logging if set.
-   [Optional] `SxsPath`: Specifies a custom path to the SXS folder.

## Fallback to Configuration File

If a parameter is not provided via the command line, the script will attempt to read it from the `config.json` file. If the parameter is still not available, the script will try offline installation first and then online if offline fails.

## OS Version Detection

The script automatically detects the Windows version using `(Get-WmiObject Win32_OperatingSystem).Caption` and sets the `SxsPath` accordingly:

-   For Windows 10, it uses `source\w10\sxs`.
-   For Windows 11, it uses `source\w11\sxs`.

If the OS version is unsupported, the script will skip offline installation and proceed with online installation unless the `-Offline` parameter is specified, in which case it will fail.

## Install Script

### Description

The install script installs **.NET Framework 3.5** using the specified parameters. 

### Usage
```powershell
.\install.ps1 [-Online] [-Offline] [-Logging] [-SxsPath <PathToSxsFolder>]
```

### Example Usage

-   Default installation (no logging, try offline first with fallback to online):


```powershell
.\install.ps1
```

-   Online installation:

```powershell
.\install.ps1 -Online
```

-   Offline installation with custom SXS path:

```powershell
.\install.ps1 -Offline -SxsPath "C:\Path\To\SXS"
```

-   Enable logging:

```powershell
.\install.ps1 -Logging
```

## Uninstall Script

### Description

The uninstall script removes **.NET Framework 3.5** using the specified parameters.

### Usage

To run the uninstall script, use the following command:


```powershell'
.\uninstall.ps1 [-Logging]
```

### Parameters

-   [Optional] `Logging`: Enables transcript logging if set.

### Example Usage

-   Default uninstallation (no logging):

```powershell
.\uninstall.ps1
```

-   Enable logging:

```powershell
.\uninstall.ps1 -Logging
```

## Check Script

### Description

The check script verifies if **.NET Framework 3.5** is installed and outputs "Detected" or "NotDetected". It uses exit codes compatible with Intune: `0` for success (detected) and `1` for failure (not detected).

### Usage

To run the check script, use the following command:


```powershell
.\check.ps1
```

### Parameters

The `check.ps1` script does not accept any parameters.

### Example Usage

-   Check if **.NET Framework 3.5** is installed:
```powershell
.\check.ps1
```

## Logging

### Description

The install and uninstall scripts support transcript logging to capture detailed information about the script execution. Logging can be enabled via the `-Logging` parameter or the configuration file.

### How It Works

When logging is enabled, the scripts will start a PowerShell transcript at the beginning of the execution and stop it at the end. This transcript will include all commands executed and their output, providing a detailed log of the script's actions.

### Enabling Logging

Logging can be enabled by setting the `-Logging` parameter when running the script, or by setting the `Logging` property to `true` in the `config.json` file.

### Log File Location

The log files are stored in the temporary directory of the user running the script. The log file names follow the pattern:

-   For the install script: `installation_log_NetFx3.txt`
-   For the uninstall script: `uninstallation_log_NetFx3.txt`
-   For the check script: `check_log_NetFx3.txt`

Example log file paths:

-   `C:\Users\<Username>\AppData\Local\Temp\installation_log_NetFx3.txt`
-   `C:\Users\<Username>\AppData\Local\Temp\uninstallation_log_NetFx3.txt`
-   `C:\Users\<Username>\AppData\Local\Temp\check_log_NetFx3.txt`

**System Account Exception**: When scripts are run as the System account, such as during automated deployments or via certain administrative tools, the log files will be stored in the `C:\Windows\Temp` directory instead of the user's local temporary directory.

### Example

To enable logging via the command line:

``` powershell
.\install.ps1 -Logging
```
``` powershell
.\uninstall.ps1 -Logging
```

Or by setting the `Logging` property in the configuration file:

``` json
{
    "Online": false,
    "Offline": false,
    "Logging": true
}
```

## Error Handling

All scripts include error handling to provide clear messages when parameters are missing or actions fail. If any required parameter is missing and cannot be resolved, the scripts will fail with an appropriate error message.

## Contents

-   `install.ps1`: The script for installing **.NET Framework 3.5**.
-   `uninstall.ps1`: The script for uninstalling **.NET Framework 3.5**.
-   `check.ps1`: The script for checking installation status of **.NET Framework 3.5**.
-   `config.json`: Configuration file for default values.
-   `source\w10\sxs`: CAB files for Windows 10.
-   `source\w11\sxs`: CAB files for Windows 11.

## Notes

-   Ensure you have the correct .CAB file(s) in the SXS for your Windows version in the respective `source\w10\sxs` or `source\w11\sxs` folders. You can also specify your own location for the SXS folder.

## How to get the CAB files for your version of windows
You can get the CAB files by doing the following:

 1. Mount your Windows ISO.
 2. Browse to `\sources\sxs`.
 3. Find the file(s) containing **netfx3** in the filename.
 4. Copy these files to a directory and point to it via the `-SxsPath` parameter.

## Troubleshooting

If you encounter any issues, ensure that all parameters are correctly specified and that the printer driver is available at the provided path. Check the error messages provided by the scripts for further details on what might have gone wrong.

# GNU General Public License v3.0 (GPLv3)

The  **GNU General Public License v3.0 (GPLv3)**  is a free, copyleft license for software and other creative works. It ensures your freedom to share, modify, and distribute all versions of a program, keeping it free software for everyone.

Full license can be read  [here](https://github.com/tommyvange/Printer-Driver-Management-Scripts/blob/main/LICENSE)  or at  [gnu.org](https://www.gnu.org/licenses/gpl-3.0.en.html#license-text).

## Key Points:

1.  **Freedom to Share and Change:**
    
    -   You can distribute copies of GPLv3-licensed software.
    -   Access the source code.
    -   Modify the software.
    -   Create new free programs using parts of it.
2.  **Responsibilities:**
    
    -   If you distribute GPLv3 software, pass on the same freedoms to recipients.
    -   Provide the source code.
    -   Make recipients aware of their rights.
3.  **No Warranty:**
    
    -   No warranty for this free software.
    -   Developers protect your rights through copyright and this license.
4.  **Marking Modifications:**
    
    -   Clearly mark modified versions to avoid attributing problems to previous authors.