@{

# Script module or binary module file associated with this manifest.
RootModule = './PSc8y.DeviceManagement.psm1'

# Version number of this module.
ModuleVersion = '1.0.0'

# Supported PSEditions
# Supported PSEditions
CompatiblePSEditions = @(
    "Desktop",
    "Core"
)

# ID used to uniquely identify this module
GUID = '5d0118bb-9212-4964-8357-05ef7f97b897'

# Author of this module
Author = 'Reuben Miller'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2021. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A Cumulocity REST API PowerShell module'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(
    @{ModuleName="PSc8y"; ModuleVersion="1.9.1"; GUID="9b4ebc35-bd61-4d07-a528-81c5733d0732"}
)

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @(
    'views/configuration.ps1xml',
    'views/firmware.ps1xml',
    'views/software.ps1xml'
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    #Prerelease of this module
    Prerelease = ''

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @(
            'Cumulocity',
            'IoT',
            'REST-API',
            'Windows',
            'Linux',
            'MacOS',
            'PSEdition_Desktop',
            'PSEdition_Core'
        )

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
DefaultCommandPrefix = ''

}