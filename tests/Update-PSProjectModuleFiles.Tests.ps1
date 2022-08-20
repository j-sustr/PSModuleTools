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
                    Private = @('funcA')
                    Public  = @('FuncB')
                }
            }
        }
        Mock Update-ModuleManifest {
            $args
        }
        Mock Set-Content {}

        $info = Update-PSProjectModuleFiles

        Should -Invoke -CommandName Update-ModuleManifest -Times 1 -ParameterFilter { $Path -eq 'dummymanifestpath.psd1' -and $RootModule -eq 'dummyscriptmodulepath.psm1' }
        # $FunctionsToExport -eq @('FuncB')

        $expectedScriptModuleContent = ''

        Should -Invoke -CommandName Set-Content -Times 1 -ParameterFilter { $Path -eq 'dummyscriptmodulepath.psm1' -and $Value -eq $expectedScriptModuleContent }
    }
}
