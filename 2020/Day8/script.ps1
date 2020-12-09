$ErrorActionPreference='Stop'
$in = Get-Content $PSScriptRoot/input
$h=@{}
$r=[System.Collections.ArrayList]@()
$v=[System.Collections.ArrayList]@()
[int]$ins=1
$in | ForEach-Object {
    $obj=[PSCustomObject]@{
        CMD = $_.split(" ")[0]
        ARG = $_.split(" ")[1]
    }
    $h.Add($ins, $obj)
    $ins++
}
$h.Add(0,$null)
foreach ($item in $h.GetEnumerator() | Sort-Object | Where-Object {($_.Value).CMD -in ('nop','jmp',$null)}) {
    $v.Add($item.Name) | Out-null
}

foreach($v1 in $v | Sort-Object) {
    [int]$acc=0
    [int]$nextCMD = 1
    [int]$pLines=0
    foreach ($line in $h.GetEnumerator() | Sort-Object Name | Where-Object {$_.Value.CMD -ne $null}) {
        $command = $h[$nextCMD]
        $cLine = $nextCMD
        if ($nextCMD -eq $v1) {
            switch ($command.CMD) {
                "nop" { $cmd = "jmp" }
                "jmp" { $cmd = "nop" }
            }
        }
        else {
            $cmd=$command.CMD
        }
        switch ($cmd) {
            "nop" {
                $nextCMD++
            }
            "acc" {
                $acc += $command.ARG
                $nextCMD++
            }
            "jmp" {
                $nextCMD += $command.ARG
            }
        }
        $pLines++
        $r.Add($cLine) | Out-Null
        if ($nextCMD -in $r -and $null -ne $command) {
            break
        }
    }
    $r.Clear()
    if($pLines -ne $h.Count -1 -and $v1 -eq 0) {
        Write-Output "Stage #1. Loop. ACC: $acc"
    }
    elseif($pLines -eq ($h.Count -1) ) {
        Write-Output "Stage #2. Completed. ACC: $acc"
        break
    }
    $r.Clear()
}