
# Get public and private function definition files
$Public  = @( Get-ChildItem -Path $PSScriptRoot\public\ -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\ -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue )


# Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        Write-Verbose ("Importing: {0}" -f $import.FullName)
        . $import.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Expose public functions
foreach($publicFile in @($Public)) {
    Write-Verbose "Making: $($publicFile.Basename) public"
    Export-ModuleMember -Function $publicFile.Basename
}

# Add/Override views
Get-ChildItem -Path "$PSScriptRoot/views" | ForEach-Object {
    Update-FormatData -PrependPath $_.FullName
}

# Add/Override types
Get-ChildItem -Path "$PSScriptRoot/types" | ForEach-Object {
    Update-TypeData -PrependPath $_.FullName
}

# Export aliases
Export-ModuleMember -Alias *

#region tab completion
$Manifest = Test-ModuleManifest -Path $PSScriptRoot\PSc8y.DeviceManagement.psd1
$ModulePrefix = $Manifest.Prefix

$ModuleCommands = @( $Manifest.ExportedFunctions.Keys ) `
    | ForEach-Object {
        # Note: Different PowerShell version handle internal function names 
        # slightly differenty (some with prefix sometimes without), so we always
        # look for both of them.
        #
        $Name = "$_"
        $NameWithoutPrefix = $Name.Replace("-${ModulePrefix}", "-")

        if (Test-Path "Function:\$Name") {
            Get-Item "Function:\$Name"
        } elseif (Test-Path "Function:\$NameWithoutPrefix") {
            Get-Item "Function:\$NameWithoutPrefix"
        } else {
            throw "Could not find function '$Name'"
        }
    }

$ModuleCommands | PSc8y\Register-ClientArgumentCompleter

#endregion tab completion

