Function Get-SmartGroupCollection {
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "None",
        DefaultParameterSetName = "IncludeInvisible"
    )]
    Param(
        # Firmware name. Case sensitive
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Name = '*',


        # Include invisible smart groups
        [Parameter(
            ParameterSetName = "IncludeInvisible"
        )]
        [switch]
        $IncludeInvisible,

        # Only include invisible smart groups
        [Parameter(
            ParameterSetName = "OnlyInvisible"
        )]
        [switch]
        $OnlyInvisible
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Collection" }

    Process {
        $Query = "type eq 'c8y_DynamicGroup' and name eq '{0}'" -f $Name

        switch ($PSCmdlet.ParameterSetName) {
            "IncludeInvisible" {
                if (!$IncludeInvisible) {
                    $Query += " and not(has(c8y_IsDynamicGroup.invisible))"
                }
            }
            "OnlyInvisible" {
                if ($OnlyInvisible) {
                    $Query += " and has(c8y_IsDynamicGroup.invisible)"
                }
            }
        }
        
        $null = $PSBoundParameters.Remove("Name")
        $null = $PSBoundParameters.Remove("OnlyInvisible")
        $null = $PSBoundParameters.Remove("IncludeInvisible")

        Find-ManagedObjectCollection -Query $Query @PSBoundParameters -OrderBy "name" `
        | Select-Object `
        | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customSmartGroup+json"
    }

}