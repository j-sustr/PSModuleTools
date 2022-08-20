BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Get-PSProjectCodeInfo.ps1
}

Describe 'Get-PSProjectCodeInfo Tests' {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
        $sampleProjectPath = Join-Path $PSScriptRoot 'data\sampleproject'
    }

    It 'Gets PSProject code info' {
        Mock Get-GitDirectory {
            return "$sampleProjectPath\.git"
        }

        $info = Get-PSProjectCodeInfo $modulePath

        $info | Should -HaveProperty ModuleManifestPath "$sampleProjectPath\src\sampleproject.psd1"

    }
}