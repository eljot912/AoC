$in = (((Get-Content $PSScriptRoot/input) -join " ") -split "  ").replace(" ","")
$q=[System.Collections.ArrayList]@()
$a=[System.Collections.ArrayList]@()
[int]$g = 1
$in | ForEach-Object {
    $_.ToCharArray() | ForEach-Object {
        $a.Add($_) | Out-Null
    }
    $ua=$a | Select-Object -Unique
    $q.Add([PSCustomObject]@{
        Group = $g
        Any = $ua -join("")
    })| Out-Null
    $g++
    $a.Clear()
}

$st1=($q.Any | ForEach-Object {$_.length} | Measure-Object -Sum).Sum
Write-Output "Stage #1: -> $st1"
