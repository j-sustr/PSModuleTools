

function Update-PSProjectModuleFiles {
    [CmdletBinding()]
    param (
        [string]
        $SrcRoot = (getSrcRoot),

        # Ignore Git repo status
        [Switch]
        $Force
    )

    # Check Git repo status
    if (-not $Force.IsPresent) {
        assertRepoHasNoWorking
    }
    Assert-PSModuleProjectFiles $SrcRoot

    $projectInfo = Get-PSProjectCodeInfo $SrcRoot

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
