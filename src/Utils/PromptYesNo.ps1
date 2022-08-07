
function PromptYesNo([string][ValidateNotNullOrEmpty()]$title, [string][ValidateNotNullOrEmpty()]$questions) {
    $choices = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
        return $true
    }
    return $false
}