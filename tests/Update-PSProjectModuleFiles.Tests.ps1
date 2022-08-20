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
                SrcPath                = 'src'
                ModuleManifestFilePath = 'dummymanifestpath.psd1'
                ScriptModuleFilePath   = 'dummyscriptmodulepath.psm1'
                Functions              = @{
                    Private = @('FuncA')
                    Public  = @('funcB')
                }
            }
        }
        Mock Update-ModuleManifest {}
        Mock Set-Content {}

        $info = Update-PSProjectModuleFiles 

        Should -Invoke -CommandName Update-ModuleManifest -Times 1 -ParameterFilter { $value -eq 'lol' }
    }
}