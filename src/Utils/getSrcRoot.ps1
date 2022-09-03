

function getSrcRoot {
    $repoRoot = getRepoRoot
    return Join-Path $repoRoot 'src'
}
