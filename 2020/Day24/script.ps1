$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input
$h=[System.Collections.Hashtable]@{}

function Get-Deltas ([string]$direction) {
	switch ($direction) {
		'e' { $move = @(1,0) }
		'w' { $move = @(-1,0) }
		'se' { $move = @(1,1) }
		'sw' { $move = @(0,1) }
		'ne' { $move = @(0,-1) }
		'nw' { $move = @(-1,-1) }
	}
	return $move
}

function Invoke-Move ([string]$line) {
	$directions = [regex]::Matches($line,'e|se|sw|w|nw|ne')

	[int]$x=0
	[int]$y=0
	foreach ($direction in $directions.Value) {
		[int]$dx,[int]$dy = Get-Deltas $direction
		$x+=[int]$dx
		$y+=[int]$dy
	}
	return @($x,$y)
}

$in | ForEach-Object {
	$x,$y = Invoke-Move $_
	if ($null -ne $h["$x;$y"]) {
		$h.Remove("$x;$y")
	}
	else {
		$h["$x;$y"] = 1
	}
}

$st1=$h.Count
Write-Output "Stage #1: -> $st1"