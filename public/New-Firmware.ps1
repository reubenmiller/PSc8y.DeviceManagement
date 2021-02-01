Function New-Firmware {
    <#
.SYNOPSIS
Create a new firmware package

.EXAMPLE
New-Firmware -Name my-custom-package

Add a new item in the firmware package repository called "my-custom-package"

.EXAMPLE
New-Firmware -Name my-custom-package -TypeFilter "deviceType1"

Add a new item in the firmware package repository that is only valid for devices with type "deviceType1"

.EXAMPLE
New-Firmware -Name my-custom-package -Data @{ my_CustomType = "myMarker" }

Add a new item in the firmware package repository with a custom fragment

#>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]
    Param(
        # Firmware name
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $Name,

        # Type filter. The firmware package will only be selectable for devices matching this type filter
        [string]
        $TypeFilter
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Create", "Template" -BoundParameters $PSBoundParameters }
    Process {
        $BoundParameters = @{} + $PSBoundParameters
        $BoundParameters.Remove("Name")
        $BoundParameters.Remove("TypeFilter")

        if (!$BoundParameters.ContainsKey("Data")) {
            $BoundParameters["Data"] = @{}
        }

        $BoundParameters["Data"].name = $Name
        $BoundParameters["Data"].type = "c8y_Firmware"
        $BoundParameters["Data"].c8y_Global = @{}

        if (!$BoundParameters["Data"].c8y_Filter) {
            $BoundParameters["Data"].c8y_Filter = @{}
        }
        if ($TypeFilter) {
            $BoundParameters["Data"].c8y_Filter.type = $TypeFilter
        }

        New-ManagedObject @BoundParameters `
        | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customFirmware+json"
    }
}
