


function Get-ModulePath {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [switch] $LatestVersion
    )

    $modules = Get-Module -Name $Name -ListAvailable
    | Sort-Object -Property Version -Descending

    if ($LatestVersion.IsPresent) {
        return $modules[0].Path
    }

    return $modules.Path
}
