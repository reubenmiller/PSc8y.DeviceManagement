Function Set-FailOperation {
    <#
.SYNOPSIS
Set an operation to failed

.EXAMPLE
Set-FailOperation -Id 12345

Set an operation to failed by referencing the operation id

.EXAMPLE
Get-OperationCollection -Device 12345 -Status EXECUTING | Set-FailOperation

Fail all EXECUTING operations from Device with id 12345

.EXAMPLE
Get-OperationCollection -BulkOperationId 12 -Status PENDING | Set-FailOperation

Fail all PENDING operations from a bulk operation

#>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]
    Param(
        # Firmware name
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [object[]]
        $Id
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Create", "Template" -BoundParameters $PSBoundParameters }
    Process {
        $BoundParameters = @{} + $PSBoundParameters
        $BoundParameters.Remove("Id")

        foreach ($iID in (PSc8y\Expand-Id $Id)) {
            Update-Operation -Id $iID -Status "FAILED" -FailureReason "Operation cancelled by user." @BoundParameters `
            | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.operation+json"
        }
    }
}
