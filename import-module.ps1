
$moduleManifestPath = Convert-Path $PSScriptRoot\src\*.psd1
$module = Import-Module $moduleManifestPath -Force -PassThru -Verbose
