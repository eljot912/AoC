
### refactor needed

$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input
$h=@{}
$ht=@{}
$lno=$in.Count

function Search-Adjacent {
    [CmdletBinding()]
    param (
        [int]
        $cord1,
        [int]
        $cord2
    )

    [int]$acount=0
    #check left
    [int]$pos=0
    do {
        $pos++
        $sIndex="$([int]$cord1);$($cord2-$pos)"
        $s=$h[$sIndex]
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }

    #check right
    [int]$pos=1
    do {
        $s=$h["$([int]$cord1);$([int]$cord2+$pos)"]
        $pos++
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }

    #check down
    [int]$pos=1
    do {
        $s=$h["$([int]$cord1+$pos);$([int]$cord2)"]
        $pos++
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }

    #check up
    [int]$pos=1
    do {
        $s=$h["$([int]$cord1-$pos);$([int]$cord2)"]
        $pos++
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }

    #check leftup
    [int]$pos=1
    do {
        $s=$h["$([int]$cord1-$pos);$([int]$cord2-$pos)"]
        $pos++
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }

    #check leftdown
    [int]$pos=1
    do {
        $s=$h["$([int]$cord1+$pos);$([int]$cord2-$pos)"]
        $pos++
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }

    #check rightup
    [int]$pos=1
    do {
        $s=$h["$([int]$cord1-$pos);$([int]$cord2+$pos)"]
        $pos++
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }

    #check rightdown
    [int]$pos=1
    do {
        $s=$h["$([int]$cord1+$pos);$([int]$cord2+$pos)"]
        $pos++
    } while ($s -eq '.' -and $null -ne $s)
    if( $s -eq '#'){
        $aCount++
    }
    return $aCount
}

for ($x=0;$x -lt $lno;$x++ ) {

    $line=$in[$x].ToCharArray()
    $cNo=$line.Count
    for ($y = 0; $y -lt $cno;$y++) {
        $h["$x;$y"] = $line[$y]
    }
}

[int]$poSeats=0
[int]$r=1
do {
    Write-Output " Counting seats, Round#$r."
    $poSeats = $coSeats
    [int]$count=0
    foreach ($seat in $h.GetEnumerator()) {
        $cords=$seat.Name.split(";")
        $cX=$cords[0]
        $cY=$cords[1]
        if( $seat.Value -eq '.') {
            $switched = $seat.Value
        }
        else {
            $oaSeats=Search-Adjacent $cX $cY
            if( $seat.Value -eq 'L' -and $oaSeats -eq 0)
            {
                $switched='#'
            }
            elseif ($seat.Value -eq '#' -and $oaSeats -ge 5) {
                $switched='L'
            }
            else {
                $switched = $seat.Value
            }
        }
        $ht["$($seat.Name)"] = $switched
        $count++
        }
    $h=$ht.Clone()
    $ht.Clear()
    $coSeats=($h.GetEnumerator() | Where-Object {$_.Value -eq '#'}).Count
    $r++
} while ($poSeats -ne $coSeats) 

Write-Output "----------"
Write-Output " Stage #2 ->: $coSeats"
