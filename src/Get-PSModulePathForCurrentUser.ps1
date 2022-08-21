

function Get-PSModulePathForCurrentUser {
    param ()

    if (-not (Test-Path variable:HOME)) {
        throw 'Variable HOME must be defined.'
    }

    $path = $env:PSModulePath.Split(';').Where({
            $_ -like "$HOME\*"
        }, 'First', 1)

    if (-not $path) {
        throw 'No PSModulePath for CurrentUser'
    }

    return $path
}
