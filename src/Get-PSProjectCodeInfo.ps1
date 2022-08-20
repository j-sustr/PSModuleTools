

function Get-PSProjectCodeInfo {
    [CmdletBinding()]
    param (
        [string]
        $Path = '.'
    )
    
    # --- paths ---
    $repoPath = Split-Path (Get-GitDirectory -Path $Path) -Parent
    $srcPath = Join-Path $repoPath 'src'
    $moduleManifestPath = getModuleManifestPath $srcPath
    
    # --- code ---
    $codeInfo = Get-ChildItem -Path $srcPath -Recurse -Filter *.ps1 | Get-PSCodeInfo
    if ($codeInfo.Errors) {
        throw "Project has errors: $($codeInfo.Errors)"
    }

    $functionGroups = $codeInfo.Functions | Group-Object -Property { $_ -cmatch '^[a-z]' ? 'Private' : 'Public' } -AsHashTable
    # $nestedModules = @()

    return [PSCustomObject]@{
        SrcPath            = $srcPath
        ModuleManifestPath = $moduleManifestPath
        Functions          = $functionGroups
        IsModule           = $true
    }
}


function getModuleManifestPath($srcPath) {
    $manifestPath = Get-ChildItem $srcPath -Filter *.psd1
    if ($null -eq $manifestPath) {
        throw "There must be a .psd1 file in '$srcPath'"
    }
    if ($manifestPath.Count -gt 1) {
        throw "There must be only one .psd1 file in '$srcPath'"
    }
    return $manifestPath
}