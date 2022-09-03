
function getRepoRoot {
    return Split-Path (Get-GitDirectory) -Parent
}
