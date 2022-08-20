
$modulePath = Convert-Path $PSScriptRoot\..\src
$moduleManifestPath = "$modulePath\PSModuleTools.psd1"

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
$module = Import-Module $moduleManifestPath -Force -PassThru