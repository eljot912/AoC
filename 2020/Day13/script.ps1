$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input
$h=[ordered]@{}
$depart=$in[0]
$t=[System.Collections.ArrayList]@()

[int]$count=0
$in[1].split(',') | ForEach-Object {
    if($_ -ne 'x') {
        $h["$count"] = [PSCustomObject]@{
            hID=$count
            ID=$_
        }
    }
    $count++
}

$h.Values | ForEach-Object {
    $waitTime=$_.ID - ($depart % $_.ID)
    $t.Add([PSCustomObject]@{
        ID = $_.ID
        Time = $waitTime
    }) | Out-Null
}
$r=($t | Sort-Object Time | Select-Object -First 1)
$st1=[int]$r.ID * [int]$r.Time

$buses=($h.GetEnumerator() | Sort-Object Name ).value
[long]$time=0
[long]$offset=$buses[0].ID
foreach ($bus in $buses) {
    while (([long]$time + [long]$bus.hID) % $bus.ID -ne 0) {
        $time += $offset
    }
    if ($bus.HID -ne 0) {
        [long]$offset *= [long]$bus.ID
    }
}
$st2=$time

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"