$in = Get-Content $PSScriptRoot/input
$sl = @('1.1','3.1','5.1','7.1','1.2')
[long]$trees=1
$sl | ForEach-Object {
    $dRight=$_.split(".")[0]
    $dDown=$_.split(".")[1]
    $dIndex = 0
    $slope = 0
    $dTrees = 0
    $in | ForEach-Object {
        if ($slope % $dDown -eq 0) {
            $end=$_.length
            while ($dIndex -ge $end) {
                $dIndex = $dIndex - ($end * [math]::Truncate($dIndex/$end))
            }
            if($_[$dIndex] -eq '#') {
                $dTrees++
            }
            $dIndex+=$dRight
        }
        $slope++
    }
    if($dRight -eq 3 -and $dDown -eq 1) {
        Write-Output "Stage #1: -> $dTrees"
    }
    $trees *= $dTrees
}
Write-Output "Stage #2: -> $trees"