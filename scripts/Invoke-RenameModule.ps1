[cmdletbinding()]
Param(
    # Name of the module
    [Parameter(
        Mandatory = $true,
        Position = 0
    )]
    [string] $Name,

    # Create a copy of the module in another path
    [string] $OutputFolder,

    # Author of the module. Defaults to the current user name
    [string] $Author = [Environment]::UserName    
)

$TemplateFolder = "$PSScriptRoot/../"

$SkipCopy = $False

if (!$OutputFolder) {
    $SkipCopy = $true
    $ModuleBasePath = "$TemplateFolder"
} else {
    $ModuleBasePath = Join-Path $OutputFolder $Name
}


if (!(Test-Path $ModuleBasePath)) {
    $null = New-Item $ModuleBasePath -Force -ItemType Directory
}

if (-Not $SkipCopy) {
    # Copy module template
    Copy-Item -Path "$TemplateFolder/*" -Exclude "$ModuleBasePath" -Destination $ModuleBasePath -Recurse
}

# Get existing name
$PSM1 = Get-ChildItem -Path $ModuleBasePath -Filter "*.psm1" | Select-Object -First 1
$PSD1 = Get-ChildItem -Path $ModuleBasePath -Filter "*.psd1" | Select-Object -First 1


# Build new psd1 file
# Update module meta data (replace GUID, auth)
$Contents = Get-Content $PSD1
$Contents = $Contents -replace "GUID\s*=\s*.*$", "GUID = '$([guid]::NewGuid().Guid)'"
$Contents = $Contents -replace "RootModule\s*=\s*.*$", "RootModule = './${Name}.psm1'"
$Contents = $Contents -replace "ModuleVersion\s*=\s*.*$", "ModuleVersion = '1.0.0'"
$Contents = $Contents -replace "Author\s*=\s*.*$", "Author = '$([environment]::UserName)'"
($Contents -join "`n") | Out-File $PSD1 -NoNewline

# Rename module files
Rename-Item -Path $PSM1 -NewName "${Name}.psm1"
Rename-Item -Path $PSD1 -NewName "${Name}.psd1"

$ModuleBasePath = Resolve-Path $ModuleBasePath

if ($SkipCopy) {
    Write-Host "Renamed module to ${Name}. Path=${ModuleBasePath}" -ForegroundColor Magenta
} else {
    Write-Host "Created new module: Name=${Name}. Path=${ModuleBasePath}" -ForegroundColor Magenta
}

Get-Item $ModuleBasePath
