$ErrorActionPreference = 'Stop'
class StageOne {
    [long]$digit = 0

    StageOne ( [long]$inputValue ) {
        $this.digit = $inputValue
    }

    [long] GetDigit() {
        return $this.digit
    }

    static [StageOne] op_Addition([StageOne]$First, [StageOne]$Second) {
        return [StageOne]::new($First.GetDigit() + $Second.GetDigit())
    }
    static [StageOne] op_Subtraction([StageOne]$First, [StageOne]$Second) {
        return [StageOne]::new($First.GetDigit() * $Second.GetDigit())
    }
}
class StageTwo {
    [long]$digit = 0

    StageTwo ( [long]$inputValue ) {
        $this.digit = $inputValue
    }

    [long] GetDigit() {
        return $this.digit
    }

    static [StageTwo] op_Subtraction([StageTwo]$First, [StageTwo]$Second) {
        return [StageTwo]::new($First.GetDigit() * $Second.GetDigit())
    }
    static [StageTwo] op_Division([StageTwo]$First, [StageTwo]$Second) {
         return [StageTwo]::new($First.GetDigit() + $Second.GetDigit())
    }
}

$in = Get-Content $PSScriptRoot/input
$st1Data=$in.Replace(" ","").replace("*","-") -replace '(\d+)','[StageOne]::new($1)'
$st2Data=$in.Replace(" ","").replace("*","-").replace("+","/") -replace '(\d+)','[StageTwo]::new($1)'
[long]$st1=0
[long]$st2=0
$st1Data | ForEach-Object {
    $st1 += (Invoke-Expression $_).digit + 0
}
$st2Data | ForEach-Object {
    $st2 += (Invoke-Expression $_).digit + 0
}

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"