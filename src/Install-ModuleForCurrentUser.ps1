

function Install-ModuleForCurrentUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $ModuleRoot,

        [Parameter(Position = 1)]
        [version]
        $Version = "0.0.1.0"
    )

    # $version = [version] (Get-Metadata -Path $ManifestPath -PropertyName 'ModuleVersion')

    $path = Get-PSModulePathForCurrentUser

    if ($path -and (Test-Path -Path $path)) {
        "Using [$path] as base path..."
        $path = Join-Path -Path $path -ChildPath $ModuleName
        $path = Join-Path -Path $path -ChildPath $Version

        "Creating directory at [$path]..."
        New-Item -Path $path -ItemType 'Directory' -Force -ErrorAction 'Ignore'

        "Copying items from [$ModuleRoot] to [$path]..."
        Copy-Item -Path "$ModuleRoot\*" -Destination $path -Recurse -Force
    }
}
