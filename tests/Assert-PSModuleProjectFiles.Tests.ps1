BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Assert-PSModuleProjectFiles.ps1
}

Describe 'Assert-PSModuleProjectFiles Tests' {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
        $sampleSrcPath = Join-Path $PSScriptRoot 'data\sampleproject\src'
    }

    It 'PS Module Project Files are correct' {
        Assert-PSModuleProjectFiles $sampleScriptPath | Should -Not -Throw
    }
}
