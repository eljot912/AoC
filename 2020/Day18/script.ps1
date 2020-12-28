$ErrorActionPreference = 'Stop'
class NumeroUno {
    [long]$digit = 0

    NumeroUno ( [long]$inputValue ) {
        $this.digit = $inputValue
    }

    [long] GetDigit() {
        return $this.digit
    }

    static [NumeroUno] op_Addition([NumeroUno]$First, [NumeroUno]$Second) {
        return [NumeroUno]::new($First.GetDigit() + $Second.GetDigit())
    }
    static [NumeroUno] op_Subtraction([NumeroUno]$First, [NumeroUno]$Second) {
        return [NumeroUno]::new($First.GetDigit() * $Second.GetDigit())
    }
}
class NumeroDuo {
    [long]$digit = 0

    NumeroDuo ( [long]$inputValue ) {
        $this.digit = $inputValue
    }

    [long] GetDigit() {
        return $this.digit
    }

    static [NumeroDuo] op_Subtraction([NumeroDuo]$First, [NumeroDuo]$Second) {
        return [NumeroDuo]::new($First.GetDigit() * $Second.GetDigit())
    }
    static [NumeroDuo] op_Division([NumeroDuo]$First, [NumeroDuo]$Second) {
         return [NumeroDuo]::new($First.GetDigit() + $Second.GetDigit())
    }
}

$in = Get-Content $PSScriptRoot/input
$st1Data=$in.Replace(" ","").replace("*","-") -replace '(\d+)','[numerouno]::new($1)'
$st2Data=$in.Replace(" ","").replace("*","-").replace("+","/") -replace '(\d+)','[numeroduo]::new($1)'
[long]$st1=0
[long]$st2=0
$st1Data | ForEach-Object {
    $st1 += (Invoke-Expression $_).digit + 0
}
$st2Data | ForEach-Object {
    $st2 += (Invoke-Expression $_).digit + 0
}

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"