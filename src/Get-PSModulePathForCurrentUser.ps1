

function Get-PSModulePathForCurrentUser {
    param ()

    if (-not (Test-Path variable:HOME)) {
        throw "Variable HOME must be defined."
    }

    $path = $env:PSModulePath.Split(';').Where({
            $_ -like "$home\*"
        }, 'First', 1)

    return $path
}