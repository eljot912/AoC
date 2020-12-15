$ErrorActionPreference='Stop'
$in = Get-Content $PSScriptRoot/input
$h=@{}
$arrIn=$in.split(",")

function Get-StartingNumbers() {
    for ($script:i = 0; $script:i -lt $arrIn.Count-1; $script:i++) {
        $script:h["$($arrIn[$i])"] = $i+1
    }
    $lastNumber = $arrIn[$i]
    return $lastNumber
}

function Invoke-Turns([int]$ln, [long]$turns) {
    while ($i -lt $turns) {
        if ($null -eq $script:h["$ln"]) {
            $nextNumber=0
        }
        else {
            $nextNumber=[int]($i + 1) - $script:h["$ln"]
        }
        $script:h["$ln"] = $i +1
        $ln=$nextNumber
        $i++
    }
    return $h.GetEnumerator() | Where-Object Value -eq $turns
}

$st1=(Invoke-Turns -ln (Get-StartingNumbers) -turns 2020).Name
Write-Output "Stage #1: -> $st1. Wait for Stage #2 completion."
$st2=(Invoke-Turns -ln (Get-StartingNumbers) -turns 30000000).Name
Write-Output "Stage #2: -> $st2."
