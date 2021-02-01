Function New-Configuration {
    <#
    .SYNOPSIS
    Create a new configuration package

    .EXAMPLE
    New-Configuration -Name my-custom-package -File myfile.ini -Type "CONFIG_1"

    Add a new item in the configuration package repository called "my-custom-package"

    .EXAMPLE
    New-Configuration -Name my-custom-package -File myfile.ini  -Type "CONFIG_1" -Data @{ my_CustomType = "myMarker" }

    Add a new item in the configuration package repository with a custom fragment

    .EXAMPLE
    New-Configuration -Name my-custom-package -File myfile.ini  -Type "CONFIG_1" -TypeFilter "myDeviceType1"

    Add a new item in the configuration package repository that is only valid for devices with type "myDeviceType1"

    #>
    [cmdletbinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High",
        DefaultParameterSetName = "ByFile"
    )]
    Param(
        # Configuration name
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]
        $Name,

        # Configuration type
        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [string]
        $Type,

        # Configuration file to upload
        [Parameter(
            Mandatory = $true,
            Position = 2,
            ParameterSetName = "ByFile"
        )]
        [ValidateScript( {
                Test-Path $_
            })]
        [string]
        $File,

        # External url where the file is stored (outside of Cumulocity)
        [Parameter(
            Mandatory = $true,
            Position = 2,
            ParameterSetName = "ByUrl"
        )]
        [string]
        $Url,

        # Type filter. The configuration file will only be available for devices matching this type
        [string]
        $TypeFilter
    )
    DynamicParam { PSc8y\Get-ClientCommonParameters -Type "Create", "Template" -BoundParameters $PSBoundParameters }
    Process {
        $BoundParameters = @{} + $PSBoundParameters
        $BoundParameters.Remove("Name")
        $BoundParameters.Remove("Type")
        $BoundParameters.Remove("TypeFilter")
        $BoundParameters.Remove("File")
        $BoundParameters.Remove("Url")


        if ($File) {
            # upload file
            $BinaryData = @{
                c8y_Global = @{}
                type       = "c8y_upload"
            }
            $Binary = PSc8y\New-Binary -File $File -Data $BinaryData -ErrorAction Stop
            $ConfigUrl = $Binary.self
        } else {
            # external url
            $ConfigUrl = $Url
        }

        # create config item
        if (!$BoundParameters.ContainsKey("Data")) {
            $BoundParameters["Data"] = @{}
        }
        if ($TypeFilter) {
            $BoundParameters["Data"].deviceType = $TypeFilter
        }
        $BoundParameters["Data"].name = $Name
        $BoundParameters["Data"].configurationType = $Type
        $BoundParameters["Data"].type = "c8y_ConfigurationDump"
        $BoundParameters["Data"].url = $ConfigUrl
        $BoundParameters["Data"].c8y_Global = @{}

        switch ($PSCmdlet.ParameterSetName) {
            "ByFile" {
                $mo = New-ManagedObject @BoundParameters `
                    | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customConfiguration+json"

                # add binary as child addition to config item
                $AdditionOptions = @{
                    Uri = "/inventory/managedObjects/{0}/childAdditions" -f $mo.id
                    Method = "Post"
                    Data = @{
                        managedObject = @{
                            id = $Binary.id
                        }
                    }
                }
                Invoke-ClientRequest @AdditionOptions `
                    | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customConfiguration+json"

            }
            "ByUrl" {
                New-ManagedObject @BoundParameters `
                    | Add-ClientResponseType -Type "application/vnd.com.nsn.cumulocity.customConfiguration+json"
            }
        }
    }
}
