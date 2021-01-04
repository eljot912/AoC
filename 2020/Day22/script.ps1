$ErrorActionPreference = 'Stop'
$line=[System.Environment]::NewLine
$hDecks=[System.Collections.Hashtable]@{}
$decks= (Get-Content $PSScriptRoot/input -Raw) -split $line*2

foreach ($deck in $decks) {
	$dSplit=$deck.split("`n")
	$id = ($dSplit[0] | Select-String -Pattern '\d+').Matches.Value
	$hDecks.[int]$id = @($dSplit[1..($dSplit.Count)])
}

function Measure-Score {
	param (
		[System.Collections.ArrayList]
		$inputArr
	)

	[long]$score=0
	[int]$scount=1
	for ($i = $inputArr.Count - 1; $i -ge 0; $i--) {
		$score += [int]$inputArr[$i] * $scount
		$scount++
	}
	return $score
}

function Invoke-SimpleGame {
	param (
		[System.Collections.ArrayList]
		$deck_1,
		[System.Collections.ArrayList]
		$deck_2
	)
	while ($deck_1.Count -ne 0 -and $deck_2.Count -ne 0) {
		if ([int]$deck_1[0] -gt [int]$deck_2[0]) {
			$deck_1.Add($deck_1[0]) | Out-Null
			$deck_1.Add($deck_2[0]) | Out-Null
			$deck_1 = $deck_1[1..($deck_1.Count)]
			$deck_2 = $deck_2[1..($deck_2.Count)]
		}
		else {
			$deck_2.Add($deck_2[0]) | Out-Null
			$deck_2.Add($deck_1[0]) | Out-Null
			$deck_1 = $deck_1[1..($deck_1.Count)]
			$deck_2 = $deck_2[1..($deck_2.Count)]
		}
	}

	if ($deck_1.Count -gt $deck_2.Count) {
		return $deck_1
	}
	else {
		return $deck_2
	}
}

function Invoke-RecursiveGame {
	param (
		[System.Collections.ArrayList]
		$deck_1,
		[System.Collections.ArrayList]
		$deck_2
	)

	$hSet=[System.Collections.Hashtable]@{}
	while ($deck_1.Count -ne 0 -and $deck_2.Count -ne 0) {
		$sDeck_1=''
		$deck_1 | ForEach-Object {
			$sDeck_1+=[string]$_.trim()
		}
		$sDeck_2=''
		$deck_2 | ForEach-Object {
			$sDeck_2+=[string]$_.trim()
		}
		
		$key="$sDeck_1;$sDeck_2"
		if ($key -in $hSet.Keys) {
			return "One",$deck_1
			
		}
		$hSet.$key = 1
		$deck_1_0 = $deck_1[0]
		$deck_2_0 = $deck_2[0]

		if ($deck_1.Count -1 -ge [int]$deck_1_0 -and $deck_2.Count-1 -ge [int]$deck_2_0) {
			$subDeck_1 = $deck_1[1..($deck_1_0)]
			$subDeck_2 = $deck_2[1..($deck_2_0)]
			$result=Invoke-RecursiveGame -deck_1 $subDeck_1 -deck_2 $subDeck_2
			if($result[0] -eq 'One') {
				$winner = $True
			}
			else {
				$winner = $False
			}
		}
		else {
			if([int]$deck_1_0 -gt [int]$deck_2_0) {
				$winner = $True
			}
			else {
				$winner = $False
			}
		}
		
		if ($winner) {
			$deck_1.Add($deck_1_0) | Out-Null
			$deck_1.Add($deck_2_0) | Out-Null
			$deck_1 = $deck_1[1..$deck_1.Count]
			$deck_2 = $deck_2[1..$deck_2.Count]
		}
		else {
			$deck_2.Add($deck_2_0) | Out-Null
			$deck_2.Add($deck_1_0) | Out-Null
			$deck_1 = $deck_1[1..$deck_1.Count]
			$deck_2 = $deck_2[1..$deck_2.Count]
		}
	}

	if ($deck_1.Count -gt $deck_2.Count) {
		return $true,$deck_1
	}
	else {
		return $false,$deck_2
	}
}

$st1Deck=Invoke-SimpleGame $hDecks.1 $hDecks.2
$st1=Measure-Score $st1Deck
Write-Output "Stage #1: -> $st1"

$st2Deck=Invoke-RecursiveGame -deck_1 $hDecks.1 -deck_2 $hDecks.2
$st2=Measure-Score $st2Deck[1]
Write-Output "Stage #2: -> $st2"