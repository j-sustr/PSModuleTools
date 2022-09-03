BeforeAll {
    . $PSScriptRoot\Shared.ps1
    . $modulePath\Initialize-PSModuleProject.ps1
}

Describe 'Initialize-PSModuleProject Tests' {
    BeforeAll {
        $moduleDir = New-Item "$(getEmptyDirectory)/MyModule" -ItemType Directory
    }

    It 'Installs a module' {
        Initialize-PSModuleProject $moduleDir -Verbose

        "$moduleDir\src\MyModule.psd1" | Should -Exist
        "$moduleDir\src\module.psm1" | Should -Exist
    }
}
