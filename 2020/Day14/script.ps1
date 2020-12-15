$ErrorActionPreference = 'Stop'
$in = (Get-Content $PSScriptRoot/input)
$h=[ordered]@{}
$hmem=[ordered]@{}
$hs2=[ordered]@{}

function Convert-ToBinary([long]$dec,[int]$pad=36) {
    [string]$binaryValue=([convert]::ToString($dec,2)).PadLeft($pad,'0')
    return $binaryValue
}

function Convert-ToDecimal([string]$bin) {
    return ([convert]::ToInt64($bin,2))
}

function Get-FloatingAddress([string]$floating,[string]$digits) {
    [int]$nIndex=0
    [string]$resultAddress=$null
    $floating.ToCharArray() | ForEach-Object {
        if ($_ -ne 'X') {
            $resultAddress+=$_
        }
        else {
            $resultAddress+=$digits[$nIndex]
            $nIndex++
        }
    }
    return $resultAddress
}

[int]$ln=0
[int]$id=0
foreach ($entry in $in) {
    if ($in[$ln] -match '^mask.*([X01]{36})$') {
        $mask=$Matches[1]
        $mL=$null
        $mV=$null
    }
    elseif ($in[$ln] -match 'mem\[(\d+)\].*\s(\d+)') {
            $mL = $Matches[1]
            $mV = $Matches[2]
    }
    if ($null -ne $mL) {
        $h["$id"] = [PSCustomObject]@{ Mask = $mask; Memory = $mL; MValue = $mV}
        $id++
    }
    $ln++
}

[int]$IDH=1
foreach ($item in $h.Values) {
    $binaryValue=Convert-ToBinary($item.MValue)
    $binaryMemory=Convert-ToBinary($item.Memory)
    [string]$maskedBin=$null
    [string]$memAdd=$null
    [int]$floatCount=0
    for ($char = 0; $char -lt $binaryValue.Length; $char++) {
        #stage #1
        if($item.Mask[$char] -ne 'X') {
            $maskedBin+=$item.Mask[$char]
        }
        else {
            $maskedBin+=$binaryValue[$char]
        }
        #stage #2
        if($item.Mask[$char] -in ('X','1')) {

            if($item.Mask[$char] -eq 'X')
            {
                $floatCount++
            }
            $memAdd+=$item.Mask[$char]
        }
        else {
            $memAdd+=$binaryMemory[$char]
        }
    }
    [long]$cmbFloat = [math]::Pow(2,[int]$floatCount)
    $hmem["$IDH"] = [PSCustomObject]@{ Memory=$item.Memory; DecValue=$item.MValue; BinValue = $maskedBin; Address = $memAdd; FloatCombo = $cmbFloat}
    $IDH++
}
$st1=($hmem.Values.BinValue | ForEach-Object {
    Convert-ToDecimal($_)
} | Measure-Object -Sum).Sum

Write-Output "Stage #1: -> $st1 | Standby for Stage #2 calculation..."
foreach ($ad in $hmem.Values) {
    [long]$mcombo=[long]$ad.FloatCombo-1
    $minPad=(Convert-ToBinary -dec $mcombo -pad 0).Length
    for ($c = 0 ; $c -le $mcombo; $c++) {
        [string]$digits = Convert-ToBinary -dec $c -pad $minPad
        $floatingAddress = Get-FloatingAddress -floating $ad.Address -digits $digits
        [long]$decimalFloating = Convert-ToDecimal($floatingAddress)
        $hs2["$decimalFloating"] = $ad.DecValue
    }
}
[long]$st2=($hs2.Values | Measure-Object -Sum).Sum
Write-Output "Stage #2: -> $st2"
