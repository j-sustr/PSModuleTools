
$modulePath = Convert-Path $PSScriptRoot\..\src
$moduleManifestPath = "$modulePath\PSModuleTools.psd1"

function getPSModulePath {
    $path = 'TestDrive:\Modules'
    $null = New-Item $path -ItemType Directory -Force
    return $path
}

function resolveTestDriveFullPath {
    Param(
        [string] $Path
    )
    return $Path.Replace('TestDrive:', (Get-PSDrive TestDrive).Root)
}

function getSampleProjectPath {
    return Join-Path $PSScriptRoot 'data\sampleproject'
}

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$module = Import-Module $moduleManifestPath -Force -PassThru
