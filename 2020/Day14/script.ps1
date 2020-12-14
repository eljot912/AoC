$ErrorActionPreference = 'Stop'
$in = (Get-Content $PSScriptRoot/input)
$h=[ordered]@{}
$hMem=@{}

function Convert-MaskToIndexes([string]$mk) {
    $m=[System.Collections.ArrayList]@()
    $mk=Get-StringRev($mk)
    for ($j = 0; $j -lt $mk.Length; $j++) {
        if ($mk[$j] -in @('1','0')){
            $m.Add([PSCustomObject]@{ Index = $j; Mask = $mk[$j] }) | Out-Null
        }        
    }
    return $m
}

function Get-StringRev([string]$str) {
    $nStr=$str.ToCharArray()
    [array]::Reverse($nStr)
    return ($nStr -join "")
}

function Convert-ToBinary([int]$dec) {
    $binaryValue=([convert]::ToString($dec,2)).PadLeft(36,'0')
    return $binaryValue
}

function Convert-ToDecimal([string]$bin) {
    return ([convert]::ToInt64($bin,2))
}

[int]$ln=0
[int]$id=0
foreach ($entry in $in) {
    if ($in[$ln] -match '^mask.*([X01]{36})$') {
        $mask=Convert-MaskToIndexes($Matches[1])
        $mL=$null
        $mV=$null
    }
    elseif ($in[$ln] -match 'mem\[(\d+)\].*\s(\d+)') {
            $mL = $Matches[1]
            $mV = $Matches[2]
    }
    if ($null -ne $mL) {
        $h["$id"] = [PSCustomObject]@{ MK = $mask; ML = $mL; MV = $mV }
        $id++
    }
    $ln++
}

foreach ($item in $h.Values) {
    $binaryValue=Convert-ToBinary($item.MV)
    $RbinaryValue=Get-StringRev($binaryValue)
    [string]$masked=$null
    for ($char = 0; $char -lt $RbinaryValue.Length; $char++) {
        if($char -in $item.MK.Index) {
            $rMask=($item.MK | Where-Object {$_.Index -eq $char}).Mask
            $masked+=$rMask
        }
        else {
            $masked+=$RbinaryValue[$char]
        }
    }
    $fbinaryValue=Get-StringRev($masked)
    $hMem["$($item.ML)"] = $fbinaryValue
}

$st1=($hMem.Values | ForEach-Object {
    Convert-ToDecimal($_)
} | Measure-Object -Sum).Sum

Write-Output "Stage #1: -> $st1 | Stage #2: -> TBD"
