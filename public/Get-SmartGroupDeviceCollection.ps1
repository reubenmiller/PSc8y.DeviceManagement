Function Get-SmartGroupDeviceCollection {
<# 
.SYNOPSIS
Get the devices matching a Smart Group

.EXAMPLE
Get-SmartGroupDeviceCollection -Id 12345

Get the devices in the Smart Group (reference by id)

.EXAMPLE
Get-SmartGroupDeviceCollection -Id "MyName*"

Get the devices in the Smart Group (reference by name)

.EXAMPLE
Get-SmartGroupCollection -Name "MyName*" | Get-SmartGroupDeviceCollection

Get the devices in the Smart Group (using pipeline)
#>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "None"
    )]
    Param(
        # Firmware name. Case sensitive
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [object[]]
        $Id
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Collection" }

    Process {
        $null = $PSBoundParameters.Remove("Id")

        foreach ($mo in (Expand-SmartGroup $Id)) {
            if ($mo.c8y_DeviceQueryString) {
                PSc8y\Find-ManagedObjectCollection -Query $mo.c8y_DeviceQueryString @PSBoundParameters `
                    | Select-Object `
                    | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customDevice+json"
            }
        }
    }
}
