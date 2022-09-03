BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Install-ModuleForCurrentUser.ps1
}

Describe 'Install-ModuleForCurrentUser Tests' {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
        $psModulePath = getPSModulePath
    }

    It 'Installs a module' {
        Mock Update-PSModuleProjectFiles {}

        Mock Get-PSModulePathForCurrentUser {
            return $psModulePath
        }
        Mock Get-PSModulePathForCurrentUser {
            return $psModulePath
        }

        Install-ModuleForCurrentUser "$(getSampleProjectPath)\src" -Verbose

        "$psModulePath\sampleproject\0.0.1\sampleproject.psd1" | Should -Exist

        Should -Invoke -CommandName Update-PSModuleProjectFiles -Times 1 -ExclusiveFilter {
            $SrcRoot | Should -BeExactly "$testDataPath\sampleproject\src"
            return $true
        }
    }
}
