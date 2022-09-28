

function Remove-OldModuleVersions {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    $modules = Get-Module -Name $Name -ListAvailable

    $modulesToRemove = $modules | Sort-Object -Property Version -Descending | Select-Object -Skip 1

    if (!$modulesToRemove) {
        Write-Verbose 'No old module versions to be be removed.'
        return;
    }

    foreach ($module in $modulesToRemove) {
        $path = $module.Path
        Write-Verbose "Removing folder '$path'."
        Remove-Item $path -Recurse
    }
}
