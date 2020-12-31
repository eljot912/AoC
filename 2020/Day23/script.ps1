#refactor needed for part1

$ErrorActionPreference = 'Stop'
$example=3,8,9,1,2,5,4,6,7
$input=5,6,2,8,9,3,1,4,7
$tCups=[System.Collections.ArrayList]@($input)

function Find-DestinationCup {
    param (
        [System.Collections.ArrayList]
        $Cups,
        [int]
        $Destination
    )

    $Destination-=1
    $mObj=$Cups | Measure-Object -Maximum -Minimum
    $mObjMax=$mObj.Maximum
    $mObjMin=$mObj.Minimum

    while ($Destination -notin $Cups) {
        if ($Destination -lt $mObjMin) {
            $Destination=$mObjMax
        }
        else {
            $Destination--
        }
    }
    $location=Find-IndexLocation $Cups "$Destination"
    return $location,$Destination
}

function Find-IndexLocation {
    param (
        [System.Collections.ArrayList]
        $List,
        [char]
        $SearchedChar
    )

    [int]$location=($List -join '').IndexOf("$SearchedChar")
    return $location
}

$ccup=$tCups[0]
$nccup=$tCups[4]

for ($i = 1; $i -le 100; $i++) {

    $tPick=[System.Collections.ArrayList]@()
    $tNew=[System.Collections.ArrayList]@()
    $tRotate=[System.Collections.ArrayList]@()
    0..2 | ForEach-Object {
        $tPick.Add($tCups[1]) | Out-Null
        $tCups.Remove($tCups[1])
    }
    $dCupLocation, $dCupValue = (Find-DestinationCup -Cups $tCups -Destination $ccup)
    $tSuffix=$tCups[($dCupLocation+1)..($tCups.Count)]
    if($dCupLocation -gt 0) {
        $tPreffix=$tCups[0..($dCupLocation-1)]
    }
    else {
        $tPreffix=@()
    }

    foreach ($item in $tPreffix) {
        $tNew.Add($item) | Out-Null
    }
    $tNew.Add($dCupValue) | Out-Null
    foreach ($item in $tPick) {
        $tNew.Add($item) | Out-Null
    }
    foreach ($item in $tSuffix) {
        $tNew.Add($item) | Out-Null
    }
    $nextCCupLocation=Find-IndexLocation $tNew "$nccup"
    if ($nextCCupLocation -ne 0)
    {
        $tPreffix=$tNew[0..($nextCCupLocation-1)]
        $tSuffix=$tNew[($nextCCupLocation)..($tNew.Count)]

        foreach ($item in $tSuffix) {
            $tRotate.Add($item) | Out-Null
        }
        foreach ($item in $tPreffix) {
            $tRotate.Add($item) | Out-Null
        }
        $tCups=$tRotate.Clone()
    }
    
    else {
        $tCups=$tNew.Clone()
       

    }
    $ccup=$tCups[0]
    $nccup=$tCups[4]
}

$tRotate=[System.Collections.ArrayList]@()

$nextCCupLocation=Find-IndexLocation $tCups "1"
if ($nextCCupLocation -ne 0)
{
    $tPreffix=$tCups[0..($nextCCupLocation-1)]
    $tSuffix=$tCups[($nextCCupLocation)..($tCups.Count)]

    foreach ($item in $tSuffix) {
        $tRotate.Add($item) | Out-Null
    }
    foreach ($item in $tPreffix) {
        $tRotate.Add($item) | Out-Null
    }
    $tCups=$tRotate.Clone()
}

$st1=$tCups[1..$tCups.Count] -join ''
Write-Host "Stage #1: -> $st1"

#different approach for part2

[int[]]$intCups = $input
[int[]]$intCups += 10..1000001
for ($i = 0; $i -lt $input.Count-1; $i++) {
    $intCups[$input[$i]] = $input[$i+1]
}

$intCups[0] = 0
$intCups[$input[-1]] = $input.Count + 1
$intCups[1000000] = $input[0]

$ccup=$input[0]
foreach ($round in 1..10000000) {
    $pCup1 = $intCups[$ccup]
    $pCup2 = $intCups[$pCup1]
    $pCup3 = $intCups[$pCup2]
    $tPicked = @($pCup1,$pCup2,$pCup3)

    $intCups[$ccup] = $intCups[$pCup3]

    if ($ccup -eq 1 ) {
        $dCup=1000000
    }
    else {
        $dCup=$ccup-1
    }
    while ($dCup -in $tPicked) {
        if ($dCup -eq 1 ) {
            $dCup=1000000
        }
        else {
            $dCup--
        }
    }
    $intCups[$pCup3] = $intCups[$dCup]
    $intCups[$dCup] = $pCup1
    $ccup = $intCups[$ccup]
}

[long]$st2=$intCups[1] * $intCups[$intCups[1]]

Write-Output "Stage #2: -> $st2"
