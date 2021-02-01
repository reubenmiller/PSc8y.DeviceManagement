Function Get-DeviceProfileCollection {
    <#
.SYNOPSIS
Get a collection of Device Profiles stored as managed objects

.EXAMPLE
Get-DeviceProfileCollection -PageSize 100

Get a list of Device Profiles

.EXAMPLE
Get-DeviceProfileCollection -Name *c8yda*

Get all Device Profiles with "c8yda" in the name
     #>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "None"
    )]
    Param(
        # DeviceProfile name. Case sensitive
        [string]
        $Name = "*"
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Collection" }
    Process {
        $Query = "type eq 'c8y_Profile' and name eq '{0}'" -f $Name
        $null = $PSBoundParameters.Remove("Name")

        Find-ManagedObjectCollection -Query $Query @PSBoundParameters `
        | Select-Object `
        | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customDeviceProfile+json"
    }
}
