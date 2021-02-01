Function Get-FirmwareCollection {
    <#
.SYNOPSIS
Get a collection of firmware packages stored as managed objects

.EXAMPLE
Get-FirmwareCollection -PageSize 100

Get a list of firmware packages

.EXAMPLE
Get-FirmwareCollection -Name *c8yda*

Get all firmware packages with "c8yda" in the name
     #>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "None"
    )]
    Param(
        # Firmware name. Case sensitive
        [string]
        $Name = "*"
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Collection" }
    Process {
        $Query = "type eq 'c8y_Firmware' and name eq '{0}'" -f $Name
        $null = $PSBoundParameters.Remove("Name")

        Find-ManagedObjectCollection -Query $Query @PSBoundParameters `
        | Select-Object `
        | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customFirmware+json"
    }
}
