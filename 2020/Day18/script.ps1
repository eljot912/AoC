$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input
[long]$st1=0

function Get-StringMathResult($n1,$n2,[string]$op){
    switch ($op) {
        '+' { $result = [long]$n1 + [long]$n2 }
        '-' { $result = [long]$n1 - [long]$n2 }
        '*' { $result = [long]$n1 * [long]$n2 }
        '/' { $result = [long]$n1 / [long]$n2 }
    }
    return $result
}

$in | ForEach-Object {
    $line=$_.replace(" ","")
    $searchBrackets=[regex]::Matches($line,'\((\d+[+|*]\d+(?:[+|*|-]\d+)*?)\)')
    if ($searchBrackets.Success) {
        do {
            foreach($item in $searchBrackets) {
                $subItem=$item.Groups[1].Value
                $mainItem=$item.Value
                $searchMath=[regex]::Match($subItem,'^(\d+)([-|+|*])(\d+)')
                if ($searchMath.Success) {
                    do {
                        [long]$result=Get-StringMathResult -n1 $searchMath.Groups[1].Value -n2 $searchMath.Groups[3].Value -op $searchMath.Groups[2].Value
                        $subItem=[regex]::Replace($subItem,'^(\d+)([-|+|*])(\d+)',$result)
                        $searchMath=[regex]::Match($subItem,'^(\d+)([-|+|*])(\d+)')
                    } while ($searchMath.Success)
                    $line=$line.replace($mainItem,$subItem)
                }
            }
            $searchBrackets=[regex]::Matches($line,'\((\d+[+|*]\d+(?:[+|*|-]\d+)*?)\)')
        } while ($searchBrackets.Success)
    }
    $searchMath=[regex]::Match($line,'^(\d+)([-|+|*])(\d+)')
    if ($searchMath.Success) {
        do {
            [long]$result=Get-StringMathResult -n1 $searchMath.Groups[1].Value -n2 $searchMath.Groups[3].Value -op $searchMath.Groups[2].Value
            $line=[regex]::Replace($line,'^(\d+)([-|+|*])(\d+)',$result)
            $searchMath=[regex]::Match($line,'^(\d+)([-|+|*])(\d+)')
        } while ($searchMath.Success)
    }
    $st1+=$line
}
Write-Output "Stage #1: -> $st1"
