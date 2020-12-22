$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input
$h=@{}
$lno=$in.Count

function Search-Neighbors {
    [CmdletBinding()]
    param (
        [int]
        $x,
        [int]
        $y,
        [int]
        $z,
        [int]
        $w
    )
    [int]$countAlive=0
    $($x-1)..$($x+1) | ForEach-Object {
        $x1=$_
        $($y-1)..$($y+1) | ForEach-Object {
            $y1=$_
            $($z-1)..$($z+1) | ForEach-Object {
                $z1=$_
                $($w-1)..$($w+1) | ForEach-Object {
                    $w1=$_
                    $cords="$x1;$y1;$z1;$w1"
                    if (!($x -eq $x1 -and $y -eq $y1 -and $z -eq $z1 -and $w -eq $w1)) {
                        if ($script:h.ContainsKey("$cords")) {
                            $countAlive++
                        }
                    }
                }
            }
        }
    }   
    return $countAlive
}

function Get-Dimensions {
    $dim=[System.Collections.ArrayList]@()
    foreach ($cord in $script:h.Keys) {
        $dim.Add([PSCustomObject]@{
            X = $cord.split(';')[0]
            Y = $cord.split(';')[1]
            Z = $cord.split(';')[2]
            W = $cord.split(';')[3]
        }) | Out-Null
    }
   
    $bounds=[PSCustomObject]@{
        X1 = ($dim.X | Measure-Object -Minimum).Minimum - 1
        X2 = ($dim.X | Measure-Object -Maximum).Maximum + 1
        Y1 = ($dim.Y | Measure-Object -Minimum).Minimum - 1
        Y2 = ($dim.Y | Measure-Object -Maximum).Maximum + 1
        Z1 = ($dim.Z | Measure-Object -Minimum).Minimum - 1
        Z2 = ($dim.Z | Measure-Object -Maximum).Maximum + 1
        W1 = ($dim.W | Measure-Object -Minimum).Minimum - 1
        W2 = ($dim.W | Measure-Object -Maximum).Maximum + 1
    }

    return $bounds
}

function Invoke-Grow {

    [PsObject]$bounds=Get-Dimensions
    $hGrow=@{}
    $($bounds.X1)..$($bounds.X2) | ForEach-Object {
        $x0=$_
        $($bounds.Y1)..$($bounds.Y2) | ForEach-Object {
            $y0=$_
            $($bounds.Z1)..$($bounds.Z2) | ForEach-Object {
                $z0=$_
                $($bounds.W1)..$($bounds.W2) | ForEach-Object {
                    $w0=$_
                    $cubesAlive=Search-Neighbors -x $x0 -y $y0 -z $z0 -w $w0
                    $cords="$x0;$y0;$z0;$w0"
                    if ($script:h.ContainsKey("$cords") -and ($cubesAlive -eq 3 -or $cubesAlive -eq 2)) {
                        $hGrow.$cords = '#'
                    }
                    elseif ($cubesAlive -eq 3) {
                        $hGrow.$cords = '#'
                    }
                }
            }
        }
    }
    return $hGrow
}


for ($x=0;$x -lt $lno;$x++ ) {

    $line=$in[$x].ToCharArray()
    $cNo=$line.Count
    for ($y = 0; $y -lt $cno;$y++) {
        if($line[$y] -eq '#')
        {
            $h["$x;$y;0;0"] = $line[$y]
        }
        
    }
}

1..6 | ForEach-Object {
    Write-Output "Round #$_"
    $h = Invoke-Grow
}
$st2=$h.Count
Write-Output "Stage #2: -> $st2"
