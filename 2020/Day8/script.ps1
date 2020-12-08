$ErrorActionPreference='Stop'
$in = Get-Content $PSScriptRoot/input
$t=[System.Collections.ArrayList]@()
$r=[System.Collections.ArrayList]@()
$tr=[System.Collections.ArrayList]@()
[int]$ins=1

$in | ForEach-Object {
$t.Add([PSCustomObject]@{
    ID = $ins
    CMD = $_.split(" ")[0]
    ARG = $_.split(" ")[1]
    }) | Out-Null
    $ins++
}

#stage #1
[int]$acc=0
[int]$nextCMD = 1
[int]$pLines=0
foreach ($line in $t ) {
    $command = $t  | Where-Object {$_.ID -eq $nextCMD }
    switch ($command.CMD) {
        "nop" {
            #does nothing
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
if($pLines -ne $t.Count) {
    Write-Output "Stage #1: Loop Attempt. ACC: $acc"
}

#stage #2
$v = $t | Where-Object {$_.CMD -in ('nop','jmp')}
foreach($v1 in $v)
{
    $t | ForEach-Object {
        if ($v1.ID -eq $_.ID)
        {
            switch ($_.CMD) {
                "nop" { $rep = "jmp" }
                "jmp" { $rep = "nop" }
            }
        }
        else {
            $rep=$_.CMD            
        }
        $tr.Add([PSCustomObject]@{
            ID = $_.ID
            CMD = $rep
            ARG = $_.ARG
            }) | Out-Null
    }
    #checking different instructions (swapped jmp <-> nop iteration)
    [int]$acc=0
    [int]$nextCMD = 1
    [int]$pLines=0
    foreach ($line in $tr ) {
        $command = $tr  | Where-Object {$_.ID -eq $nextCMD }
        switch ($command.CMD) {
            "nop" {
                #does nothing
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
    if($pLines -eq $t.Count) {
        Write-Output "Stage #2. Completed. ACC: $acc"
        break
    }
    $r.Clear()
    $tr.Clear()
}
