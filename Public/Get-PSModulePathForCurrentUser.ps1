

function Get-PSModulePathForCurrentUser {
    param ()

    $path = $env:PSModulePath.Split(';').Where({
            $_ -like "$home\*"
        }, 'First', 1)

    return $path
}