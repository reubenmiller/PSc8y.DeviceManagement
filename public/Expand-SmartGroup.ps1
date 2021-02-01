Function Expand-SmartGroup {
    <#
    .SYNOPSIS
    Expand a list of smart groups replacing any ids or names with the actual smart group object.
    
    .DESCRIPTION
    The list of smart groups will be expanded to include the full smart group representation by fetching
    the data from Cumulocity.
    
    .NOTES
    If the given object is already an smart group object, then it is added with no additional lookup
    
    .PARAMETER InputObject
    List of ids, names or smart group objects
    
    .EXAMPLE
    Expand-SmartGroup "mysmart_group"
    
    Retrieve the smart group objects by name or id
    
    .EXAMPLE
    Get-SmartGroupCollection *test* | Expand-SmartGroup
    
    Get all the smart group object (searching by name). Note the Expand cmdlet won't do much here except for returning the input objects.
    
    
    #>
    [cmdletbinding(
        # SupportsShouldProcess = $true,
        # ConfirmImpact = "None"
    )]
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [object[]] $InputObject
    )
    
    Process {
        [array] $AllItems = foreach ($iItem in $InputObject) {
            if ($iItem.id) {
                $iItem
            }
            else {
                if ($iItem -match "^\d+$") {
                    if ($WhatIfPreference) {
                        # Fake the reponse of the managed object
                        [PSCustomObject]@{
                            id   = $iItem
                            # Dummy value
                            name = "name of $iItem"
                        }
                    }
                    else {
                        Get-ManagedObject -Id $iItem -Verbose:$VerbosePreference -WhatIf:$false
                    }
                }
                else {
                    Get-SmartGroupCollection -Name $iItem -Verbose:$VerbosePreference -WhatIf:$false
                }
            }
        }
    
        $AllItems
    }
}
