$ErrorActionPreference='Stop'
$in = Get-Content $PSScriptRoot/input | Sort-Object {[int]$_}
$t=[System.Collections.ArrayList]@()
$h1=@{}
$hDiff=@{}

$t.Add(0) | Out-Null
$in | ForEach-Object { 
     $t.Add($_) | Out-Null
}
$t.Add([int]$t[-1]+3) | Out-Null

for ($i = 0; $i -lt $t.Count-1; $i++) {
    [int]$diff=[int]$t[$i+1] - [int]$t[$i]
    $hDiff.$diff=$hDiff.$diff + 1 
}

$dV=($hDiff.GetEnumerator() | Where-Object {$_.Key -in (1,3)}).Value
$st1=$dV[0] * $dV[1]
Write-Output "Stage #1: -> $st1"

$c=$t.Count-1
for ($s = 0; $s -le $c ; $s++) {
    $h1.$s = 0
}
$h1.$c=1

while ($c -ge 0) {
    $countD=$c
    foreach ($item in 1..3) {
        [int]$range=$countD + $item
        if($range -ge $h1.Count ) {break}
        foreach ($nItem in 1..3) {
            [int]$cIndex=[int]$t[$countD] + $nItem
            [int]$oIndex =$t[$range]
            if( $cIndex -eq $oIndex) {
                $h1.$countD = $h1.$countD + $h1[$range]
            }
        }
    }
    $c--
}
$st2=$h1.0
Write-Output "Stage #2: -> $st2"