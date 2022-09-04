

function Update-PSModuleProjectFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $SrcRoot = (getSrcRoot),

        # Ignore Git repo status
        [Switch]
        $Force
    )

    # Check Git repo status
    if (-not $Force.IsPresent) {
        assertRepoHasNoWorking $SrcRoot
    }
    Assert-PSModuleProjectFiles $SrcRoot

    $projectInfo = Get-PSModuleProjectCodeInfo $SrcRoot

    # --- .psd1 ---
    $updateParams = @{
        Path              = $projectInfo.ModuleManifestFilePath
        RootModule        = Split-Path $projectInfo.ScriptModuleFilePath -Leaf
        FunctionsToExport = $projectInfo.Functions.Public
    }
    Update-ModuleManifest @updateParams

    # --- .psm1 ---
    $sortedScriptPaths = $projectInfo.ScriptFilePaths | Sort-Object
    $scriptModuleContent = formatScriptModuleContent $sortedScriptPaths

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
