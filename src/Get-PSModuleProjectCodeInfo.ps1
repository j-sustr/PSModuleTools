
<#

    Public members start with capital letter
    Private members start with lowercase letter (This can be overriden by ...)

#>
function Get-PSModuleProjectCodeInfo {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $SrcRoot = (getSrcRoot)
    )

    # --- paths ---
    Assert-PSModuleProjectFiles $SrcRoot
    $moduleManifestFilePath = Convert-Path $SrcRoot\*.psd1
    $scriptModuleFilePath = Convert-Path $SrcRoot\*.psm1

    # --- code ---
    $scriptFiles = Get-ChildItem -Path $SrcRoot -Recurse -Filter *.ps1
    $codeInfo = $scriptFiles | Get-PSCodeInfo
    if ($codeInfo.Errors) {
        throw "Project has errors: $($codeInfo.Errors)"
    }

    $functionGroups = $codeInfo.Functions | Group-Object -Property { $_ -cmatch '^[a-z]' ? 'Private' : 'Public' } -AsHashTable

    $scriptFilePaths = $scriptFiles | ForEach-Object { $_.FullName.Replace($SrcRoot, 'src') }

    # $nestedModules = @()

    return [PSCustomObject]@{
        SrcPath                = $SrcRoot
        ModuleManifestFilePath = $moduleManifestFilePath
        ScriptModuleFilePath   = $scriptModuleFilePath
        Functions              = $functionGroups
        ScriptFilePaths        = $scriptFilePaths
        IsModule               = $true
    }
}



