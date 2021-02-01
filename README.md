# About

This repository shows an example how to extend the [PSc8y](https://www.powershellgallery.com/packages/PSc8y) PowerShell module to create your own custom cmdlets/functions to interact with [CUMULOCITY IoT](https://www.softwareag.cloud/site/product/cumulocity-iot.html#/).

See the [documentation](https://reubenmiller.github.io/go-c8y-cli/docs/1-powershell-installation/) for details about using the `PSc8y` module.

## Getting started

**Pre-requisites**

These instructions require PowerShell to be already installed. PowerShell (or pwsh) is available for Windows, Linux and MacOS. Please following the instructions for your operating system [here](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7).

Powershell 7 is the current recommended version, though the instructions should also work for PowerShell 5.1 (on Windows only).


1. Open a PowerShell (pwsh) console
    ```sh
    pwsh

    # Or if you are using PowerShell 5.1 on windows
    powershell
    ```

2. Clone the project

    ```sh
    git clone https://github.com/reubenmiller/PSc8y.DeviceManagement.git
    cd PSc8y.DeviceManagement
    ```

3. Import the PowerShell module

    ```powershell
    Import-Module ./ -Force
    ```

    **Note**: The `-Force` parameter is important when re-importing a module from a directory. If it is not used and the module has already been imported once, then any new functions or changes will not be loaded!

4. Show a list of the commands in the module

    ```powershell
    Get-Command -Module PSc8y.DeviceManagement
    ```

5. Get help for a specific module

    ```powershell
    Get-Help Clear-OperationCollection -Full
    ```

# Creating a new PowerShell module from the example project

The module can be used as a template for your own PSc8y extension module. For convenience there is a script to rename the module and be used as follows:

1. Run the rename module script

    ```powershell
    ./scripts/Invoke-RenameModule.ps1 -Name "PSc8y.mymodule" -OutputFolder "../"
    ```

    **Notes**
    
    You can change the -Name parameter to anything you want. By convention the module name should start with `PSc8y.` to show that the module is an extension of `PSc8y`, however this convention is not enforced.

2. Change directory to the new module output folder, and import it into your current PowerShell session

    ```powershell
    cd "../PSc8y.mymodule"
    Import-Module ./ -Force
    ```

**Notes**

* By convention the project folder name should be the same name as the PowerShell module (i.e. the `.psd1` file, without the extension). The script will enforce this convention.

# Project Structure

The project is structured into the following folders:

## private

PowerShell functions which are only used within the module. These will NOT be available for the user when the module is imported. Only other functions within the module have access to private functions.

## public

PowerShell functions which will be available to the user when they import the module.

See [About Functions Advanced](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-7) for more information on how to write Powershell Advanced functions.

## scripts

Scripts which are used to help with the module development. These scripts will not be included in the PowerShell module as they are intended only to be run during the development.

## types

Custom type definitions, where additional properties can be added to existing types.

See [About types.ps1xml](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_types.ps1xml?view=powershell-7) for more information.

## views

Custom view definitions to control how an object looks when printed to the command console. You can define new custom views or overwrite existing views from the `PSc8y` module.

See [About Format.ps1xml](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_format.ps1xml?view=powershell-7) for more information.


## TODO

* [ ] Software
    * [x] Get-SoftwareCollection
    * [ ] Get-Software
    * [ ] Remove-Software (and all child additions/versions?)
    * [ ] New-SoftwareVersion
    * [ ] Get-SoftwareVersion
    * [ ] Update-SoftwareVersion
    * [ ] Remove-SoftwareVersion
    * [ ] Expand-Software

* [ ] Firmware
    * [x] Get-FirmwareCollection
    * [ ] Get-Firmware
    * [ ] Update-Firmware
    * [ ] Remove-Firmware
    * [ ] Expand-Firmware

* [ ] Configuration
    * [x] Get-ConfigurationCollection
    * [ ] Get-Configuration
    * [x] New-Configuration
    * [ ] Update-Configuration
    * [ ] Remove-Configuration
    * [ ] Expand-Configuration

* [ ] Device TrustedCertificates
    * [ ] New-TrustedCertificate
    * [ ] Get-TrustedCertificate
    * [ ] Get-TrustedCertificateCollection
    * [ ] Update-TrustedCertificate
    * [ ] Remove-TrustedCertificate

* [ ] Operations
    * [ ] Send-RestartOperation
    * [ ] Send-FetchLatestMeasurements
    * [ ] Send-DeviceShellOperation
    * [ ] Set-DeviceConfiguration -Type etc.
    * [ ] Get-DeviceConfiguration -Type etc.
    * [ ] Get-DeviceLogFile -Type etc.
    * [ ] Find-DeviceLogFile -Type etc.
    * [ ] Find-DeviceConfiguration -Type etc. ? Download it?
    * [ ] New-RemoteAccessOperation
