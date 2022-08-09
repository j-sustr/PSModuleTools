
function pairwise {
    # convert enumerator to array
    $array = @($Input)

    if ($array.Count -lt 2) {
        # no pairs
        return @()
    }

    0..($array.Count - 2) | ForEach-Object {
        [System.Tuple]::Create($array[$_], $array[$_ + 1])
    }
}