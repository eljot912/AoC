$in=Get-Content $PSScriptRoot/input
$t=[System.Collections.ArrayList]@()

$in | ForEach-Object {
    [int]$f1=[System.Math]::Truncate([int]$_ / 3) - 2
    [int]$f2=$f1
    [int]$fa=$f2
    while ($fa -gt 0) {
        $fa=[System.Math]::Truncate([int]$fa / 3) - 2
        if ($fa -le 0) { break }
        $f2+=$fa
    }
    $t.Add([PSCustomObject]@{
        Mass = $_
        Fuel = $f1
        MoreFuel = $f2
    }) | Out-Null
}

$t
$s1 = ($t.Fuel | Measure-Object -Sum).sum
$s2 = ($t.MoreFuel | Measure-Object -Sum).sum
Write-Output "Stage #1: -> $s1 | Stage #2: -> $s2"