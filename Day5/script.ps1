$dataInput = Get-Content ./input
$t=[System.Collections.ArrayList]@()
$m=[System.Collections.ArrayList]@()
[string]$b=$null

enum Seats {
    R = 1
    L = 0
    B = 1
    F = 0
}

$dataInput | ForEach-Object {
    $c=$_
    $c.ToCharArray() | ForEach-Object {
        $b+=[Seats]::$_.value__
    }
    [string]$bR=$b.Substring(0,7)
    [string]$bC=$b.Substring(7,3)
    $t.Add([PSCustomObject]@{
        Code = $c
        RowBin = $bR
        ColBin = $bC
        RowDec = [convert]::ToInt32($bR,2)
        ColDec = [convert]::ToInt32($bC,2)
        SeatId = ([convert]::ToInt32($bR,2) *8 + [convert]::ToInt32($bC,2))
    }) | Out-Null
    $b = $null
}
$mID = $t | Measure-Object SeatID -Maximum -Minimum

for ($i = $mID.Minimum; $i -le $mid.Maximum; $i++) {
    if ($t.SeatId -notcontains $i) {
        $m.Add($i) | Out-Null
    }
}

Write-Output "Stage #1: MaxId: $($mID.maximum) | Stage #2: MySeat#: $m"