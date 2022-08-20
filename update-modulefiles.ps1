$srcPath = "$PSScriptRoot\src"
. $srcPath\Get-PSCodeInfo.ps1
. $srcPath\Get-PSProjectCodeInfo.ps1
. $srcPath\Update-PSProjectModuleFiles.ps1


Update-PSProjectModuleFiles -Force