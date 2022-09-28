
Update-PSModuleProjectFiles $PSScriptRoot\src -ErrorAction Stop

Install-ModuleForCurrentUser $PSScriptRoot\src
