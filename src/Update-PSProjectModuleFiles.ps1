

function Update-PSProjectModuleFiles {
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

    # --- .psd1 ---
    $updateParams = @{
        Path              = $projectInfo.ModuleManifestFilePath
        RootModule        = Split-Path $projectInfo.ScriptModuleFilePath -Leaf
        FunctionsToExport = $projectInfo.Functions.Public
    }
    Update-ModuleManifest @updateParams

    # --- .psm1 ---
    $scriptModuleContent = formatScriptModuleContent $projectInfo.ScriptFilePaths

    Set-Content -Path $projectInfo.ScriptModuleFilePath -Value $scriptModuleContent
}


function formatScriptModuleContent($scriptPaths) {
    $sb = [System.Text.StringBuilder]::new()

    foreach ($path in $scriptPaths) {
        $path = $path -replace '^src\\', '$PSScriptRoot\'
        [void]$sb.AppendLine(". $path")
    }

    return $sb.ToString()
}
