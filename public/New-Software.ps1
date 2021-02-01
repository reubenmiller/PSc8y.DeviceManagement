Function New-Software {
<# 
.SYNOPSIS
Create a new software package

.EXAMPLE
New-Software -Name my-custom-package

Add a new item in the software package repository called "my-custom-package"

.EXAMPLE
New-Software -Name my-custom-package -Data @{ my_CustomType = "myMarker" }

Add a new item in the software package repository with a custom fragment

#>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]
    Param(
        # Software name
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $Name
    )
    DynamicParam {PSc8y\Get-ClientCommonParameters -Type "Create", "Template" -BoundParameters $PSBoundParameters}
    Process {
        $BoundParameters = @{} + $PSBoundParameters
        $BoundParameters.Remove("Name")

        if (!$BoundParameters.ContainsKey("Data")) {
            $BoundParameters["Data"] = @{}
        }

        $BoundParameters["Data"].name = $Name
        $BoundParameters["Data"].type = "c8y_Software"
        $BoundParameters["Data"].c8y_Global = @{}

        New-ManagedObject @BoundParameters `
            | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customSoftware+json"
    }
}
