
<#

    Public members start with capital letter
    Private members start with lowercase letter (This can be overriden by ...)

#>

function Update-ModuleManifestOfProject {
    [CmdletBinding()]
    param (
        [string]
        $Path = "."
    )
    
    $repoPath = Split-Path (Get-GitDirectory -Path $Path) -Parent

    # Check Git repo status
    if ((Get-GitStatus).HasWorking) {
        # throw "Repo '$repoPath' has working files"
        Write-Warning "Repo '$repoPath' has working files"
    }

    $srcPath = Join-Path $repoPath "src"
    $manifestFile = Get-ChildItem $srcPath -Filter *.psd1
    if ($null -eq $manifestFile) {
        throw "There must be a .psd1 file in '$srcPath'"
    }
    if ($manifestFile.Count -gt 1) {
        throw "There must be only one .psd1 file in '$srcPath'"
    }

    $codeInfo = Get-ChildItem -Path $srcPath -Recurse -Filter *.ps1 | Get-PSCodeInfo
    
    $functionGroups = $codeInfo.Functions | Group-Object -Property { $_ -cmatch "^[a-z]" ? "Private" : "Public" } -AsHashTable

    # $nestedModules = @()

    (Get-ChildItem -Filter *.ps1)

    $updateParams = @{
        Path              = $manifestPath.FullName
        FunctionsToExport = $functionGroups.Public
    }
    Update-ModuleManifest @updateParams

}


Update-ModuleManifestOfProject