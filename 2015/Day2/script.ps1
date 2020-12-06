class Present {

    [int]$l
    [int]$h
    [int]$w
    [int]$ar
    [int]$rb
    
    Present ([int]$l,[int]$h,[int]$w) {
        $this.l=$l
        $this.h=$h
        $this.w=$w

        [int]$lw = $l * $w
        [int]$lh = $l * $h
        [int]$hw = $h * $w
        $a=@($lw,$hw,$lh) | Sort-Object | Select-Object -First 1
        $this.ar = 2 * $lw + 2 * $lh + 2 * $hw + $a
        $r= @($l,$h,$w) | Sort-Object | Select-Object -First 2
        $this.rb = 2*$r[0]+2*$r[1] + $l * $h * $w
    
    }
}

$in = Get-Content $PSScriptRoot/input
$t=[System.Collections.ArrayList]@()
[int]$st1=0
[int]$st2=0
$in | ForEach-Object {
    $dim=$_.split("x")
    $t.Add([Present]::new($dim[0],$dim[1],$dim[2])) | out-null
}

$st1 = ($t.ar | Measure-Object -sum).sum
$st2 = ($t.rb | Measure-Object -sum).sum

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"
