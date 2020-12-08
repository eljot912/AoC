$ErrorActionPreference='Stop'
$in = Get-Content $PSScriptRoot/input
$h=@{}
$t=[System.Collections.ArrayList]@()
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
$IdList=$h.Values | Where-Object {$_.CMD -in ('nop','jmp')}


foreach($v1 in ($h.Keys | Sort-Object ))
{
    $v1
    exit
    [int]$acc=0
    [int]$nextCMD = 1
    [int]$pLines=0
    foreach ($line in $t ) {
        $command = $t  | Where-Object {$_.ID -eq $nextCMD }
        if ($command.ID -eq $v1) {
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
        $r.Add($command.ID) | Out-Null
        if ($nextCMD -in $r) {
            break
        }
    }
    $r.Clear()
    if($pLines -ne $t.Count -and $v1 -eq 0) {
        Write-Output "Stage #1. Loop. ACC: $acc"
    }
    elseif($pLines -eq $t.Count) {
        Write-Output "Stage #2. Completed. ACC: $acc"
        break
    }
    $r.Clear()
}
