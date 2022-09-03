

function Initialize-PSModuleProject {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $RepoRoot = (getRepoRoot),

        [string]
        $ModuleName
    )

    if (-not $ModuleName) {
        $ModuleName = Split-Path $RepoRoot -Leaf
    }

    $srcRoot = Join-Path $repoRoot 'src'
    if (-not (Test-Path $srcRoot)) {
        "Creating directory '$srcRoot'"
        New-Item -Path $srcRoot -ItemType Directory
    }

    if (-not (Test-Path $srcRoot\*.psd1)) {
        $psd1Path = "$srcRoot\$ModuleName.psd1"
        "Creating module manifest file '$psd1Path'"
        New-ModuleManifest -Path $psd1Path -RootModule 'module.psm1'
    }
    if (-not (Test-Path $srcRoot\*.psd1)) {
        $psd1Path = "$srcRoot\module.psm1"
        "Creating script module file '$srcRoot'"
        New-Item -Path $srcRoot -ItemType File
    }

    Assert-PSModuleProjectFiles $srcRoot
}

