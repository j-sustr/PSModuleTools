
<#

    Public members start with capital letter
    Private members start with lowercase letter (This can be overriden by ...)

#>

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
    $scriptModuleContent = formatScriptModuleContent $projectInfo.Functions

    Set-Content -Path $projectInfo.ScriptModuleFilePath -Value $scriptModuleContent
}


function formatScriptModuleContent($functions) {
    $sb = [System.Text.StringBuilder]::new()
    
    [void]$sb.AppendLine('# Private')
    foreach ($func in $functions.Private) {
        [void]$sb.AppendLine(". `$PSScriptRoot\$func.ps1")    
    }
    [void]$sb.AppendLine()

    [void]$sb.AppendLine('# Public')
    foreach ($func in $functions.Public) {
        [void]$sb.AppendLine(". `$PSScriptRoot\$func.ps1")
    }

    return $sb.ToString()
}