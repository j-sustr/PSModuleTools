BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Update-PSModuleProjectFiles.ps1
}

Describe 'Update-PSModuleProjectFiles Tests' {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
        $sampleScriptPath = Join-Path $PSScriptRoot 'data\sampleproject\src\Get-Something.ps1'
    }

    It 'Updates PSProject module files' {
        Mock Get-GitDirectory {
            return Join-Path $PSScriptRoot 'data\sampleproject\.git'
        }
        Mock Get-GitStatus {
            return @{
                HasWorking = $false
            }
        }
        Mock Get-PSModuleProjectCodeInfo {
            return @{
                SrcPath                = 'src'
                ModuleManifestFilePath = 'dummymanifestpath.psd1'
                ScriptModuleFilePath   = 'dummyscriptmodulepath.psm1'
                ScriptFilePaths        = @('src\utils\FuncB.ps1', 'src\utils\funcA.ps1')
                Functions              = @{
                    Private = @('funcA')
                    Public  = @('FuncB')
                }
            }
        }
        Mock Update-ModuleManifest {
            $args
        }
        Mock Set-Content {

        }

        Update-PSModuleProjectFiles

        Should -Invoke -CommandName Update-ModuleManifest -Times 1 -ExclusiveFilter { $Path -eq 'dummymanifestpath.psd1' -and $RootModule -eq 'dummyscriptmodulepath.psm1' }
        # $FunctionsToExport -eq @('FuncB')

        Should -Invoke -CommandName Set-Content -Times 1 -ExclusiveFilter {
            $Path | Should -Be 'dummyscriptmodulepath.psm1'
            $Value | Should -Be (@(
                    '. $PSScriptRoot\utils\funcA.ps1',
                    '. $PSScriptRoot\utils\FuncB.ps1'
                ) -join "`r`n" | Out-String)

            return $true
        }
        # -and $Value -eq $expectedScriptModuleContent
    }
}
