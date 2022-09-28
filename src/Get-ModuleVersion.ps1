

function Get-ModuleVersion {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    $modules = Get-Module -Name $Name -ListAvailable

    return $modules | Select-Object -ExpandProperty Version | Sort-Object -Descending
}
