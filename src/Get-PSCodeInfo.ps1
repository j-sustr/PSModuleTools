

<#


Returns:
 - public functions
 - private functions
 - 


#>

function Get-PSCodeInfo {
    param (
        
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
        }
        else {
            # else the code is already present in $Code
            $name = $Code
            $filepath = ''
        }

        $tokens = [Management.Automation.PSParser]::Tokenize($code, [ref]$errors)

        $functions = getFunctionsFromTokens($tokens)

        # return the results as a custom object
        [PSCustomObject]@{
            Name      = $name
            Path      = $filepath
            Functions = $functions
            Errors    = $errors | Select-Object -ExpandProperty Token -Property Message
        }  
    }
}

function getFunctionsFromTokens($tokens) {
    if ($tokens.Count -lt 2) {
        return @()
    }

    return 0..($tokens.Count - 2) | ForEach-Object {
        $isKeyword = $tokens[$_].Type -eq "Keyword"
        if ($isKeyword -and $tokens[$_].Content -eq "function") {
            return $tokens[$_ + 1].Content
        }
    }
}