$ErrorActionPreference = 'Stop'
$line=[System.Environment]::NewLine
$hPuzzle=[System.Collections.Hashtable]@{}
$hCorners=[System.Collections.Hashtable]@{}
$puzzles= (Get-Content $PSScriptRoot/example -Raw) -split $line*2
[long]$st1=1

function Get-Border {
	[CmdletBinding()]
	param (
		[System.Collections.ArrayList]
		$Puzzle,
		[Char]
		$Side
	)
	[string]$border=''
	switch ($side) {
		'L' { $border += ($Puzzle | ForEach-Object { $_[0] }) -join("") }
		'R' { $border += ($Puzzle | ForEach-Object { $_[9] }) -join("") }
		'U' { $border = $Puzzle[0].trim() }
		'D' { $border = $Puzzle[-1].trim() }
	}
	return $border
}

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

	$hMatch=[System.Collections.Hashtable]@{}
	$hCor=[System.Collections.Hashtable]@{}
	$dirs=@('L','R','U','D')
	$pairs=Get-Combinations ([System.Collections.ArrayList]$script:hPuzzle.Keys)
	foreach ($pair in $pairs) {
		$pair_1 = $script:hPuzzle[$pair[0]]
		$pair_2 = $script:hPuzzle[$pair[1]]
		foreach ($side_1 in $dirs) {
			foreach ($side_2 in $dirs) {
				$border_1 = Get-Border $pair_1 $side_1
				$border_2 = Get-Border $pair_2 $side_2
				$border_R = Get-Reverse $border_2
				if ($border_1 -eq $border_2 -or $border_1 -eq $border_R) {
					$hMatch[$pair[0]] += $side_1
					$hMatch[$pair[1]] += $side_2
				}
			}
		}
	}
	
	foreach ($Item in $hMatch.GetEnumerator() ) {
		if (($item.Value).length -eq 2) {
			$hCor.($item.Key) = $item.Value
		}
	}

	return $hCor
}


foreach ($puzzle in $puzzles) {
	$id = ($puzzle | Select-String -Pattern '\d+').Matches.Value
	$hPuzzle.[int]$id = $puzzle.split("`n")[1..10]
}

$hCorners=Get-BorderMatch
$hCorners.Keys | ForEach-Object {$st1*= $_ }
Write-Output "Stage #1: -> $st1"