BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Install-ModuleForCurrentUser.ps1
}

Describe 'Install-ModuleForCurrentUser Tests' {
    BeforeAll {
        $testPSModulePath = Join-Path ([System.IO.Path]::GetTempPath()) "PowerShellTest\Modules"
        New-Item $testPSModulePath -ItemType Directory -Force
    }

    It 'Installs a module' {
        Mock Get-PSModulePathForCurrentUser {
            return $testPSModulePath
        }

        Install-ModuleForCurrentUser $modulePath

        Test-Path $testPSModulePath\
    }
}