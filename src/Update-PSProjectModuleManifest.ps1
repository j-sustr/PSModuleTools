
<#

    Public members start with capital letter
    Private members start with lowercase letter (This can be overriden by ...)

#>

function Update-PSProjectModuleManifest {
    [CmdletBinding()]
    param (
        [string]
        $Path = '.',

        [Switch]
        # Ignore Git repo status
        $Force
    )

    # Check Git repo status
    if ((Get-GitStatus).HasWorking -and (-not $Force.IsPresent)) {
        throw "Repo '$repoPath' has working files"
    }

    $projectInfo = Get-PSProjectCodeInfo $Path

    $updateParams = @{
        Path              = $projectInfo.ModuleManifestPath
        FunctionsToExport = $projectInfo.Functions.Public
    }
    Update-ModuleManifest @updateParams

}