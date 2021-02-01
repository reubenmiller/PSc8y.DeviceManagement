Function Get-SoftwareVersionCollection {
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "None"
    )]
    Param(
        # Software id
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string[]]
        $Id,

        [Parameter(
            Mandatory = $false,
            Position = 1
        )]
        [string]
        $Version
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Collection" }
    Process {
        # Clone parameter and remove custom values
        $boundParameters = @{} + $PSBoundParameters
        $null = $boundParameters.Remove("Id")
        $null = $boundParameters.Remove("Version")

        foreach ($iID in $Id) {

            $Query = "bygroupid({0})" -f $iID

            if (![string]::IsNullOrEmpty($Version)) {
                $Query += " version eq '$Version'"
            }
            $null = $boundParameters.Add("Query", $Query)

            Find-ManagedObjectCollection @boundParameters `
                | Select-Object `
                | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customSoftwareVersion+json"
        }

        #foreach ($iID in (Expand-Id $Id)) {
            # Get-SoftwareCollection -Name:$Name -PageSize 50 | ForEach-Object {
            #     $Query = "bygroupid({0})" -f $iID
            #     $null = $PSBoundParameters.TryAdd("Query", $Query)
            #     Find-ManagedObjectCollection @PSBoundParameters `
            #         | Select-Object `
            #         | Add-PowershellType -Type "application/vnd.com.nsn.cumulocity.customSoftwareVersion+json"
        #}
    }
}