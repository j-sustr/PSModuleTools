BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Get-PSModulePathForCurrentUser.ps1
}

Describe 'Get-PSModulePathForCurrentUser Tests' {
    It 'Gets PSModulePath for current user' {
        $path = Get-PSModulePathForCurrentUser

        $path | Should -BeExactly "$HOME\Documents\PowerShell\Modules"
    }
}
