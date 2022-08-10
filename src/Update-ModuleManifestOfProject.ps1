

<#

    Public members start with capital letter
    Private members start with lowercase letter (This can be overriden by ...)

#>

function Update-ModuleManifestOfProject {
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

    $scripts = Get-ChildItem -Path $srcPath -Recurse -Filter *.ps1

    $codeInfo = Get-PSCodeInfo $scripts
    
    $functionGroups = $codeInfo.Functions | Group-Object -Property { $_ -cmatch "^[a-z]" ? "Private" : "Public" } -AsHashTable

    $nestedModules = @()
    $functionsToExport = @()

}


Update-ModuleManifestOfProject