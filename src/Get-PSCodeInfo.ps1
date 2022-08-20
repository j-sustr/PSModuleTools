

<#

#>

function Get-PSCodeInfo {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param
    (
        [string]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Path')]
        [Alias('FullName')]
        $Path,

        [string]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Code')]
        $Code
    )

    begin {
        $errors = $null
    }
    process {
        # create a variable to receive syntax errors:
        $errors = $null
        # tokenize PowerShell code:

        # if a path was submitted, read code from file,
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $code = Get-Content -Path $Path -Raw -Encoding Default
            $name = Split-Path -Path $Path -Leaf
            $filepath = $Path
        } else {
            # else the code is already present in $Code
            $name = $Code
            $filepath = ''
        }

        $tokens = [Management.Automation.PSParser]::Tokenize($code, [ref]$errors)

        # TODO: Get function aliases
        $functions = @(getFunctionsFromTokens($tokens))

        # TODO: Get variables
        $variables = @()

        [PSCustomObject]@{
            Name      = $name
            Path      = $filepath
            Functions = $functions
            Variables = $variables
            Errors    = $errors | Select-Object -ExpandProperty Token -Property Message
        }
    }
}

function getFunctionsFromTokens($tokens) {
    if ($tokens.Count -lt 2) {
        return @()
    }

    return 0..($tokens.Count - 2) | ForEach-Object {
        $isKeyword = $tokens[$_].Type -eq 'Keyword'
        if ($isKeyword -and $tokens[$_].Content -eq 'function') {
            return $tokens[$_ + 1].Content

            # TODO:
            # return @{
            #     Type = 'Function|Variable'
            #     Name = ''
            #     Aliases = @()
            # }
        }
    }
}
