$ErrorActionPreference = 'Stop'
[int]$input_1 = 9033205
[int]$input_2 = 9281649
[long]$st1 = 1
[int]$loopSize = 1
[int]$subjectNumer = 7

while ($subjectNumer -ne $input_1 -and $subjectNumer -ne $input_2) {
	$subjectNumer = ($subjectNumer * 7 ) % 20201227
	$loopSize++
}

for ($i = 1; $i -le $loopSize; $i++) {
	
	$st1 = $st1 * 9033205 % 20201227
}

Write-Output "Stage #1: -> $st1"
