$srcPath = "$PSScriptRoot\src"
. $srcPath\utils\getRepoRoot.ps1
. $srcPath\utils\getSrcRoot.ps1
. $srcPath\Assert-PSModuleProjectFiles.ps1
. $srcPath\Get-PSCodeInfo.ps1
. $srcPath\Get-PSModuleProjectCodeInfo.ps1
. $srcPath\Update-PSModuleProjectFiles.ps1


Update-PSProjectModuleFiles -Force
