

function Install-ModuleForCurrentUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $ModuleRoot
    )

    $psModulePath = Get-PSModulePathForCurrentUser
    if (-not (Test-Path $psModulePath)) {
        throw "PSModulePath '$psModulePath' does not exist"
    }

    $manifestPath = Get-ChildItem $ModuleRoot -Filter *.psd1 | Select-Object -First 1
    if (-not $manifestPath) {
        throw "Module '$ModuleRoot' does not contain a *.psd1 file"
    }

    $moduleName = $manifestPath | Split-Path -LeafBase
    $version = [version] (Get-Metadata -Path $manifestPath -PropertyName 'ModuleVersion')

    "Using [$psModulePath] as base path..."
    $destPath = Join-Path $psModulePath $moduleName $version

    "Creating directory at [$destPath]..."
    New-Item -Path $destPath -ItemType 'Directory' -Force -ErrorAction 'Ignore'

    "Copying items from [$ModuleRoot] to [$destPath]..."
    Copy-Item -Path "$ModuleRoot\*" -Destination $destPath -Recurse -Force
}
