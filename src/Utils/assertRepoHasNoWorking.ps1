

function assertRepoHasNoWorking($path) {
    Push-Location $path

    $gitStatus = (Get-GitStatus)

    if ($gitStatus.HasWorking) {
        $repoRoot = Split-Path $gitStatus.GitDir -Parent

        throw "Repo '$repoRoot' has working files"
    }

    Pop-Location
}
