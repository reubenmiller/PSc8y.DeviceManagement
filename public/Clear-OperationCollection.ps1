Function Clear-OperationCollection {
<# 
.SYNOPSIS
Cancel operations which are currently in EXECUTING status

.EXAMPLE
Clear-OperationCollection -Device 12345

Set all executing operations for device id 12345 to FAILED

.OUTPUTS
None
#>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]
    Param(
        # Device
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [object[]] $Device,

        # Operation status
        [ValidateSet(
            "EXECUTING",
            "PENDING"
        )]
        [string] $Status = "EXECUTING",

        # Failure reason. Defaults to "Manually cancelled"
        [string] $FailureReason = "Manually cancelled",

        # Don't prompt for confirmation
        [switch] $Force
    )

    Process {
        foreach ($iDevice in (PSc8y\Expand-Device $Device)) {

            [array] $operations = PSc8y\Get-OperationCollection `
                -Device $iDevice `
                -Status $Status
            
            if ($operations.Count -gt 0) {
                $operations | PSc8y\Update-Operation `
                    -Status FAILED `
                    -FailureReason "Manually cancelled" `
                    -Force:$Force `
                    -Verbose:$VerbosePreference `
                    -WhatIf:$WhatIfPreference
            } else {
                Write-Warning ("Device [{0} ({1})] does not have any operations in [$Status] status" -f @(
                    $iDevice.name,
                    $iDevice.id
                ))
            }
        }
    }
}