BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Update-PSProjectModuleFiles.ps1
}

Describe 'Update-PSProjectModuleFiles Tests' {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
        $sampleScriptPath = Join-Path $PSScriptRoot 'data\sampleproject\src\Get-Something.ps1'
    }

    It 'Updates PSProject module files' {
        Mock Get-GitStatus {
            return @{
                HasWorking = $false
            }
        }
        Mock Get-PSProjectCodeInfo {
            return @{
                HasWorking = $false
            }
        }
        Mock Update-ModuleManifest {}

        $info = Update-PSProjectModuleFiles 

        $info.Functions | Should -BeExactly @('Get-Something', 'doSomething')
    }
}