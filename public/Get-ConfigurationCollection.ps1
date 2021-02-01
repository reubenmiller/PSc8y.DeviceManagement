Function Get-ConfigurationCollection {
    <#
.SYNOPSIS
Get a collection of configuration packages stored as managed objects in Cumulocity

.EXAMPLE
Get-ConfigurationCollection -PageSize 100

Get a list of configuration packages

.EXAMPLE
Get-ConfigurationCollection -Name *c8yda*

Get all configuration packages with "c8yda" in the name
     #>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "None"
    )]
    Param(
        # Configuration name. Case sensitive
        [string]
        $Name = "*"
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Collection" }
    Process {
        $Query = "type eq 'c8y_ConfigurationDump' and name eq '{0}'" -f $Name
        $null = $PSBoundParameters.Remove("Name")

        Find-ManagedObjectCollection -Query $Query @PSBoundParameters `
        | Select-Object `
        | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customConfiguration+json"
    }
}
