BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Install-ModuleForCurrentUser.ps1
}

Describe 'Install-ModuleForCurrentUser Tests' {
    BeforeAll {
        $psModulePath = getPSModulePath
    }

    It 'Installs a module' {
        Mock Get-PSModulePathForCurrentUser {
            return $psModulePath
        }

        Install-ModuleForCurrentUser "$(getSampleProjectPath)\src" -Verbose

        "$psModulePath\sampleproject\0.0.1\sampleproject.psd1" | Should -Exist
    }
}
