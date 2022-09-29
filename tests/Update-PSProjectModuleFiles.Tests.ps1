BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Update-PSModuleProjectFiles.ps1
}

# Describe 'Debug' {
#     It 'Run' {
#         Update-PSModuleProjectFiles -SrcRoot 'C:\__work__\powershell-modules\PSMetaUtils\src' -Force
#     }
# }

Describe 'Update-PSModuleProjectFiles Tests' {
    BeforeAll {
        Mock Get-GitDirectory {
            return Join-Path $PSScriptRoot 'data\sampleproject\.git'
        }
        Mock Get-GitStatus {
            return @{
                HasWorking = $false
            }
        }
        Mock Update-ModuleManifest {
            $args
        }
        Mock Set-Content {

        }
    }

    It 'Updates PSProject module files' {
        Mock Get-PSModuleProjectCodeInfo {
            return @{
                SrcPath                = 'src'
                ModuleManifestFilePath = 'dummymanifestpath.psd1'
                ScriptModuleFilePath   = 'dummyscriptmodulepath.psm1'
                ScriptFilePaths        = @('src\File1.ps1', 'src\utils\FuncB.ps1', 'src\utils\funcA.ps1')
                Functions              = @{
                    Private = @('funcA')
                    Public  = @('FuncB')
                }
            }
        }

        Update-PSModuleProjectFiles

        Should -Invoke -CommandName Update-ModuleManifest -Times 1 -ExclusiveFilter { $Path -eq 'dummymanifestpath.psd1' -and $RootModule -eq 'dummyscriptmodulepath.psm1' }
        # $FunctionsToExport -eq @('FuncB')

        Should -Invoke -CommandName Set-Content -Times 1 -ExclusiveFilter {
            $Path | Should -Be 'dummyscriptmodulepath.psm1'
            $Value | Should -Be (@(
                    '. $PSScriptRoot\utils\funcA.ps1',
                    '. $PSScriptRoot\utils\FuncB.ps1',
                    '. $PSScriptRoot\File1.ps1'
                ) -join "`r`n" | Out-String)

            return $true
        }
        # -and $Value -eq $expectedScriptModuleContent
    }

    It 'Updates PSProject module files - with init.ps1' {
        Mock Get-PSModuleProjectCodeInfo {
            return @{
                SrcPath                = 'src'
                ModuleManifestFilePath = 'dummymanifestpath.psd1'
                ScriptModuleFilePath   = 'dummyscriptmodulepath.psm1'
                ScriptFilePaths        = @('src\File1.ps1', 'src\utils\FuncB.ps1', 'src\utils\funcA.ps1')
                Functions              = @{
                    Private = @('funcA')
                    Public  = @('FuncB')
                }
            }
        }

        Mock Test-Path {
            return $true
        } -Verifiable -ParameterFilter {
            $Path -like 'src\init.ps1'
        }

        Update-PSModuleProjectFiles

        Should -Invoke -CommandName Update-ModuleManifest -Times 1 -ExclusiveFilter { $Path -eq 'dummymanifestpath.psd1' -and $RootModule -eq 'dummyscriptmodulepath.psm1' }
        Should -Invoke -CommandName Test-Path -Times 1 -ExclusiveFilter { $Path -eq 'src\init.ps1' }

        Should -Invoke -CommandName Set-Content -Times 1 -ExclusiveFilter {
            $Path | Should -Be 'dummyscriptmodulepath.psm1'
            $Value | Should -Be (@(
                    '. $PSScriptRoot\init.ps1',
                    '',
                    '. $PSScriptRoot\utils\funcA.ps1',
                    '. $PSScriptRoot\utils\FuncB.ps1',
                    '. $PSScriptRoot\File1.ps1'
                ) -join "`r`n" | Out-String)

            return $true
        }
        # -and $Value -eq $expectedScriptModuleContent
    }
}
