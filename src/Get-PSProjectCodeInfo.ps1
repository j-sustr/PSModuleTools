

function Get-PSProjectCodeInfo {
    [CmdletBinding()]
    param (
        [string]
        $Path = '.'
    )
    
    # --- paths ---
    $repoPath = Split-Path (Get-GitDirectory -Path $Path) -Parent
    $srcPath = Join-Path $repoPath 'src'
    $moduleManifestFilePath = getModuleManifestFilePath $srcPath
    $scriptModuleFilePath = getScriptModuleFilePath $srcPath
    
    # --- code ---
    $codeInfo = Get-ChildItem -Path $srcPath -Recurse -Filter *.ps1 | Get-PSCodeInfo
    if ($codeInfo.Errors) {
        throw "Project has errors: $($codeInfo.Errors)"
    }

    $functionGroups = $codeInfo.Functions | Group-Object -Property { $_ -cmatch '^[a-z]' ? 'Private' : 'Public' } -AsHashTable
    # $nestedModules = @()

    return [PSCustomObject]@{
        SrcPath                = $srcPath
        ModuleManifestFilePath = $moduleManifestFilePath
        ScriptModuleFilePath   = $scriptModuleFilePath
        Functions              = $functionGroups
        IsModule               = $true
    }
}


function getModuleManifestFilePath($srcPath) {
    $psd1Path = Get-ChildItem $srcPath -Filter *.psd1
    if ($null -eq $psd1Path) {
        throw "There must be a .psd1 file in '$srcPath'"
    }
    if ($psd1Path.Count -gt 1) {
        throw "There must be only one .psd1 file in '$srcPath'"
    }
    return $psd1Path
}

function getScriptModuleFilePath($srcPath) {
    $psm1Path = Get-ChildItem $srcPath -Filter *.psm1
    if ($null -eq $psm1Path) {
        throw "There must be a .psm1 file in '$srcPath'"
    }
    if ($psm1Path.Count -gt 1) {
        throw "There must be only one .psm1 file in '$srcPath'"
    }
    return $psm1Path
}