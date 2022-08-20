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
        Mock Get-PSCodeInfo {
            return @{
                Functions = @('FuncA', 'funcB', 'DummyFn')
            }
        }
        Mock Get-GitDirectory {
            return "$sampleProjectPath\.git"
        }

        $info = Get-PSProjectCodeInfo $modulePath


        $info

        $info.SrcPath | Should -BeExactly "$sampleProjectPath\src"
        $info.ModuleManifestFilePath | Should -BeExactly "$sampleProjectPath\src\sampleproject.psd1"
        $info.ScriptModuleFilePath | Should -BeExactly "$sampleProjectPath\src\sampleproject.psm1"
        $info.Functions | Should -BeExactly @('Get-Something')

    }
}
