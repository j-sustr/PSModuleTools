BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Assert-PSModuleProjectFiles.ps1
}

Describe 'Assert-PSModuleProjectFiles Tests' {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
        $srcRoot = Join-Path $PSScriptRoot 'data\sampleproject\src'
    }

    It 'PS Module Project Files are correct' {
        { Assert-PSModuleProjectFiles $srcRoot } | Should -Not -Throw
    }

    It 'PS Module Project Files are missing' {
        $srcRootWithMissingFiles = Join-Path $PSScriptRoot 'data\sampleproject-missingmodulefiles\src'

        { Assert-PSModuleProjectFiles $srcRootWithMissingFiles } | Should -Throw
    }
}
