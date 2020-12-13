$ErrorActionPreference='Stop'
$in = Get-Content $PSScriptRoot/input
$h=[ordered]@{}
[int]$preSize = 25
$hSet=@{}
$tPre=[System.Collections.ArrayList]@()
[int]$ins=1

$in | ForEach-Object {
    $h.Add($ins,$_)
    $ins++
}

for ($k = 1; $k -le $h.Count ; $k++) {
    if ($k -gt $preSize) {
        [int]$uk= $k - 1
        [int]$lk= $k - $preSize
        for ($i = $lk; $i -le $uk; $i++) {
            for ($j = $lk; $j -le $uk; $j++) {
                if($h.$i -ne $h.$j) {
                    [long]$sum=[long]$h.$i + [long]$h.$j
                    if ($sum -notin $tPre) {
                        $tPre.Add($sum) | Out-Null
                    }

                }
            }
        }
        if ($h.$k -notin $tPre) {
            [long]$st1= $h.$k
            break
        }
    $tPre.Clear()
    }
}
Write-Output "Stage #1: -> $st1"

for ($k = 1; $k -le $h.Count ; $k++) {
    [long]$v = $st1 - $h.$k
    [string]$d="$($h.$k)"
    $k1=$k
    while ($v -gt 0 -and $k1 -le $h.Count) {
        $k1++
        $v -= $h.$k1
        [string]$d = "$($h.$k1)," + $d
    }

    if ($v -eq 0 -and $h.$k -ne $st1) {
        $hSet.Add($k,$d)
    }
    $k1=0
    $d=$null
}

foreach ($set in $hSet.Values) {
    $m=$set.split(",") | Measure-Object -Minimum -Maximum
    [long]$st2 = [long]$m.Maximum + [long]$m.Minimum
    Write-Output "Stage #2: -> $st2"
}