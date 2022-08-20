
<#

    Public members start with capital letter
    Private members start with lowercase letter (This can be overriden by ...)

#>

function Update-PSProjectModuleManifest {
    [CmdletBinding()]
    param (
        [string]
        $Path = '.'
    )

    # Check Git repo status
    if ((Get-GitStatus).HasWorking) {
        # TODO: replace after completed implementation
        # throw "Repo '$repoPath' has working files"
        Write-Warning "Repo '$repoPath' has working files"
    }

    $projectInfo = Get-PSProjectCodeInfo $Path
    
    $functionGroups = $projectInfo.Functions | Group-Object -Property { $_ -cmatch '^[a-z]' ? 'Private' : 'Public' } -AsHashTable

    # $nestedModules = @()

    $updateParams = @{
        Path              = $projectInfo.ModuleManifestPath
        FunctionsToExport = $functionGroups.Public
    }
    Update-ModuleManifest @updateParams

}