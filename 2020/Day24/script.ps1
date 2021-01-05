#refactor for stage #2 needed.
##

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

function Search-Neighbors {
	[CmdletBinding()]
	param (
		[System.Collections.Hashtable]
		$grid,
		[int]
		$x,
		[int]
		$y
	)
	
	[int]$count=0
	$deltas = @( @(1,0), @(-1,0), @(1,1), @(0,1), @(0,-1), @(-1,-1) )
	foreach ($delta in $deltas) {
		$dx=$x+[int]$delta[0]
		$dy=$y+[int]$delta[1]
		if ($grid.ContainsKey("$dx;$dy")) {
			$count++
		}
	}
	return $count
}

function Get-Dimensions {
	param (
		[System.Collections.Hashtable]
		$grid
	)

    $dim=[System.Collections.ArrayList]@()
    foreach ($cord in $grid.Keys) {
        $dim.Add([PSCustomObject]@{
            X = $cord.split(';')[0]
            Y = $cord.split(';')[1]
        }) | Out-Null
    }
   
    $bounds=[PSCustomObject]@{
        X1 = ($dim.X | Measure-Object -Minimum).Minimum - 1
        X2 = ($dim.X | Measure-Object -Maximum).Maximum + 1
        Y1 = ($dim.Y | Measure-Object -Minimum).Minimum - 1
        Y2 = ($dim.Y | Measure-Object -Maximum).Maximum + 1
    }
    return $bounds
}

function Invoke-Grow {
	param (
		[System.Collections.Hashtable]
		$grid
	)
	
	[PsObject]$bounds=Get-Dimensions -grid $grid
    $hGrow=@{}
    $($bounds.X1)..$($bounds.X2) | ForEach-Object {
        $x0=$_
        $($bounds.Y1)..$($bounds.Y2) | ForEach-Object {
            $y0=$_
			$bTiles=Search-Neighbors -grid $grid -x $x0 -y $y0
			$cords="$x0;$y0"
            if (($grid.ContainsKey("$cords") -and $bTiles -eq 1) -or $bTiles -eq 2) {
                $hGrow.$cords = $cords
            }
        }
	}
    return $hGrow
}

$in | ForEach-Object {
	$x,$y = Invoke-Move $_
	if ($null -ne $h["$x;$y"]) {
		$h.Remove("$x;$y")
	}
	else {
		$h["$x;$y"] = "$x;$y"
	}
}

$st1=$h.Count
Write-Output "Stage #1: -> $st1"
for ($i = 1; $i -le 100; $i++) {
	$h = Invoke-Grow $h
	Write-Output "Round $i"
}
$st2=$h.Count
Write-Output "Stage #2: -> $st2"
