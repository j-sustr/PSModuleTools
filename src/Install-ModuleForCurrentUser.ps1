

function Install-ModuleForCurrentUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $ModuleRoot,

        [Parameter(Position = 1)]
        [version]
        $Version = '0.0.1'
    )

    # $version = [version] (Get-Metadata -Path $ManifestPath -PropertyName 'ModuleVersion')

    $destPath = Get-PSModulePathForCurrentUser
    if (-not (Test-Path $destPath)) {
        throw "PSModulePath '$destPath' does not exist"
    }

    $manifestPath = Get-ChildItem $ModuleRoot -Filter *.psd1 | Select-Object -First 1
    if (-not $manifestPath) {
        throw "Module '$ModuleRoot' does not contain a *.psd1 file"
    }

    $moduleName = $manifestPath | Split-Path -LeafBase

    "Using [$destPath] as base path..."
    $destPath = Join-Path -Path $destPath -ChildPath $moduleName
    $destPath = Join-Path -Path $destPath -ChildPath $Version

    "Creating directory at [$destPath]..."
    New-Item -Path $destPath -ItemType 'Directory' -Force -ErrorAction 'Ignore'

    "Copying items from [$ModuleRoot] to [$destPath]..."
    Copy-Item -Path "$ModuleRoot\*" -Destination $destPath -Recurse -Force
}
