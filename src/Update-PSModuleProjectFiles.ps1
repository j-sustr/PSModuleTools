
$initScriptName = 'init.ps1'

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
        # FIXME: Update-ModuleManifest does not accept $null
        # CmdletsToExport   = [string[]]@()
        # VariablesToExport = [string[]]@()
        # AliasesToExport   = [string[]]@()
    }
    Update-ModuleManifest @updateParams

    # --- .psm1 ---
    $scriptPathsWithoutInit = $projectInfo.ScriptFilePaths | Where-Object { $_ -ne "src\$initScriptName" }
    $hasInit = $scriptPathsWithoutInit.Count -ne $projectInfo.ScriptFilePaths.Count

    $sortedScriptPaths = sortScriptPaths $scriptPathsWithoutInit
    $scriptModuleContent = formatScriptModuleContent $sortedScriptPaths $hasInit

    Set-Content -Path $projectInfo.ScriptModuleFilePath -Value $scriptModuleContent
}

function sortScriptPaths($paths) {
    # [Array]::Copy($paths, $newPaths, $paths.Count)
    $newPaths = @() + $paths
    [Array]::Sort($newPaths, [StringComparer]::Ordinal)
    [Array]::Reverse($newPaths)
    return $newPaths
}

function formatScriptModuleContent($scriptPaths, $includeInit) {
    $sb = [System.Text.StringBuilder]::new()

    if ($includeInit) {
        [void]$sb.AppendLine('. $PSScriptRoot\{0}' -f $initScriptName)
        [void]$sb.AppendLine();
    }

    foreach ($path in $scriptPaths) {
        $path = $path -replace '^src\\', '$PSScriptRoot\'
        [void]$sb.AppendLine(". $path")
    }

    return $sb.ToString()
}
