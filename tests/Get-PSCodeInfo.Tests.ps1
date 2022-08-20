BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Get-PSCodeInfo.ps1
}

Describe 'Get-PSCodeInfo Tests' {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
        $sampleScriptPath = Join-Path $PSScriptRoot 'data\sampleproject\src\Get-Something.ps1'
    }

    It 'Gets PS code info' {
        $info = Get-PSCodeInfo -Path $sampleScriptPath

        $info.Functions | Should -BeExactly @('Get-Something', 'doSomething')
    }
}