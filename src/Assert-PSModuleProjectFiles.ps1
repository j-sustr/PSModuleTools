

function Assert-PSModuleProjectFiles {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SrcRoot = (getSrcRoot)
    )

    assertPsd1 $SrcRoot
    assertPsm1 $SrcRoot
}


function assertPsd1($srcRoot) {
    $psd1Path = Get-ChildItem $srcRoot -Filter *.psd1
    if ($null -eq $psd1Path) {
        throw "There must be a .psd1 file in '$srcRoot'"
    }
    if ($psd1Path.Count -gt 1) {
        throw "There must be only one .psd1 file in '$srcRoot'"
    }
    return $psd1Path
}

function assertPsm1($srcRoot) {
    $psm1Path = Get-ChildItem $srcRoot -Filter *.psm1
    if ($null -eq $psm1Path) {
        throw "There must be a .psm1 file in '$srcRoot'"
    }
    if ($psm1Path.Count -gt 1) {
        throw "There must be only one .psm1 file in '$srcRoot'"
    }
    return $psm1Path
}
