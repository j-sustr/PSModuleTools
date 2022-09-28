


function Get-ModulePath {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [switch] $LatestVersion
    )

    $modulePaths = Get-Module -Name $Name -ListAvailable
    | Sort-Object -Property Version -Descending
    | ForEach-Object { Split-Path $_.Path -Parent }

    if ($LatestVersion.IsPresent) {
        return $modulePaths | Select-Object -First 1
    }

    return $modulePaths
}
