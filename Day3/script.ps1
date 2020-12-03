$puzzle = Get-Content ./input
$direction = @('1.1','3.1','5.1','7.1','1.2')
[long]$trees=1
$direction | ForEach-Object {
    $dRight=$_.split(".")[0]
    $dDown=$_.split(".")[1]
    $dIndex = 0
    $slope = 0
    $dTrees = 0
    $puzzle | ForEach-Object {
        if ($slope % $dDown -eq 0) {
            $end=$_.length-1
            if ($dIndex -gt $end) {
                $extend = [math]::Truncate($dIndex / $end) + 1
                $line = $_* $extend
            }
            else {
                $line = $_
            }
            if($line[$dIndex] -eq '#') {
                $dTrees++
            }
            $dIndex+=$dRight
        }
        $slope++
    }
    Write-Output "Trees at $_`: $dTrees"
    $trees *= $dTrees
}
Write-Output "Multiply all: $trees"
