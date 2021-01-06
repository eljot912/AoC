$ErrorActionPreference = 'Stop'
$line=[System.Environment]::NewLine
$hPuzzle=[System.Collections.Hashtable]@{}
$hCorners=[System.Collections.Hashtable]@{}
$hPuzzlesFlipped =@{}
$hPuzzlesMathed =@{}
$puzzles= (Get-Content $PSScriptRoot/example -Raw) -split $line*2
[long]$st1=1

function Get-Border {
	[CmdletBinding()]
	param (
		[System.Collections.ArrayList]
		$Puzzle,
		[char]
		$Side
	)
	[string]$border=''
	switch ($side) {
		'W' { foreach ($line in $Puzzle) { $border += $line[0] } }
			#$border += ($Puzzle | ForEach-Object { $_[0] }) -join("") }
		'E' {foreach ($line in $Puzzle) { $border += $line[9] } } 
			#$border += ($Puzzle | ForEach-Object { $_[9] }) -join("") }
		'N' { $border = $Puzzle[0].trim() }
		'S' { $border = $Puzzle[-1].trim() }
	}
	return $border
}

function Invoke-Rotation {
	[CmdletBinding()]
	param (
		[System.Collections.ArrayList]
		$Puzzle
	)
	$Rotated=[System.Collections.ArrayList]@()
	$Col = $Puzzle[0].length
	for ($c = 0; $c -lt $col; $c++) {
		$nRow=''
		for ($r = $Puzzle.Count -1 ; $r -ge 0; $r--) {
			$nRow+= $Puzzle[$r][$c]
		}
		$Rotated.Add($nRow) | Out-Null
	}
	return	$Rotated
}

#Invoke-Rotation $puzzle

function Get-Reverse {
	[CmdletBinding()]
	param (
		[string]
		$inputString
	)
	$ar=$inputString.ToCharArray()
	[Array]::Reverse($ar)

	return ($ar -join "")
}

function Get-Combinations {
	[CmdletBinding()]
	param (
		[Parameter()]
		[System.Collections.ArrayList]
		$IDs
	)
	$t=[System.Collections.ArrayList]@()
	for ($i = 0; $i -lt $IDs.Count; $i++) {
		for ($j = $i+1; $j -lt $IDs.Count;$j++) {
			if ($ids[$i] -ne $ids[$j]) {
				$t.Add(@($ids[$i],$ids[$j])) | Out-Null
			}
		}
	}
	return $t
}

function Get-BorderMatch {
[CmdletBinding()]
param (
	[Parameter()]
	[system.Collections.Hashtable]
	$tiles
)
	$hMatch=[System.Collections.Hashtable]@{}
	$hCor=[System.Collections.Hashtable]@{}
	$dirs=@('W','E','N','S')
	$pairs=Get-Combinations ([System.Collections.ArrayList]$tiles.Keys)
	[int]$round=1
	foreach ($pair in $pairs) {
		if ($round % 100 -eq 0 ) {Write-Host "R :$round"}
		$pair_1 = $tiles[$pair[0]]
		$pair_2 = $tiles[$pair[1]]
		foreach ($side_1 in $dirs) {
			foreach ($side_2 in $dirs) {
				$border_1 = Get-Border $pair_1 $side_1
				$border_2 = Get-Border $pair_2 $side_2
				$border_R = Get-Reverse $border_2
				if ($border_1 -eq $border_2) {
					$hMatch[$pair[0]] += $side_1
					$hMatch[$pair[1]] += $side_2
					$script:hPuzzlesMathed[$pair[0]]+="$($pair[1]);"
					$script:hPuzzlesMathed[$pair[1]]+="$($pair[0]);"
				}
				if ($border_1 -eq $border_R){
					#$script:hPuzzlesFlipped[$pair[1]] += 1
					$hMatch[$pair[0]] += $side_1
					$hMatch[$pair[1]] += $side_2
					$script:hPuzzlesFlipped[$pair[0]]+="$($pair[1]);"
					$script:hPuzzlesMathed[$pair[0]]+="$($pair[1]);"
					$script:hPuzzlesMathed[$pair[1]]+="$($pair[0]);"
				}
			}
		}
		$round++
	}
	
	foreach ($Item in $hMatch.GetEnumerator() ) {
		if (($item.Value).length -eq 2) {
			$hCor.($item.Key) = $item.Value
		}
	}
	return $hCor,$hMatch
}


foreach ($puzzle in $puzzles) {
	$id = ($puzzle | Select-String -Pattern '\d+').Matches.Value
	$hPuzzle.[int]$id = $puzzle.split("`n")[1..10]
}


$hMatch2=@{}
$hCorners,$hMatch2=Get-BorderMatch -tiles $hPuzzle
$hCorners
Write-Host "----"
$hMatch2
Write-Host "----"
$hPuzzlesFlipped
Write-Host "----"
$hPuzzlesMathed
$hCorners.Keys | ForEach-Object {$st1*= $_ }
Write-Output "Stage #1: -> $st1"
