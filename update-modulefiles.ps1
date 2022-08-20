$srcPath = "$PSScriptRoot\src"
. $srcPath\Get-PSCodeInfo.ps1
. $srcPath\Get-PSProjectCodeInfo.ps1
. $srcPath\Update-PSProjectModuleManifest.ps1


Update-PSProjectModuleManifest -Force