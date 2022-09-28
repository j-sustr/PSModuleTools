
Update-PSModuleProjectFiles $PSScriptRoot -ErrorAction Stop

Install-ModuleForCurrentUser $PSScriptRoot\src
