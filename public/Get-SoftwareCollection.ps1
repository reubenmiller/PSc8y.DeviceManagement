Function Get-SoftwareCollection {
    <#
.SYNOPSIS
Get a collection of software packages stored as managed objects in Cumulocity

.EXAMPLE
Get-SoftwareCollection -PageSize 100

Get a list of software packages

.EXAMPLE
Get-SoftwareCollection -Name *c8yda*

Get all software packages with "c8yda" in the name
     #>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "None"
    )]
    Param(
        # Software name. Case sensitive
        [string]
        $Name = "*"
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Collection" }
    Process {
        $Query = "type eq 'c8y_Software' and name eq '{0}'" -f $Name
        $null = $PSBoundParameters.Remove("Name")

        Find-ManagedObjectCollection -Query $Query @PSBoundParameters `
        | Select-Object `
        | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customSoftware+json"
    }
}
