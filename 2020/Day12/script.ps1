$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input

class Ship1 {

    [int]$x=0
    [int]$y=0
    [Char]$face='E'

    [void] Move([string]$course) 
    {
        enum clWise {
            E = 1
            S = 2
            W = 3
            N = 4
        }
        enum aclWise {
            E = 1
            N = 2
            W = 3
            S = 4
        }
        
        function Get-Course ($course) {
            $dirs=[regex]::Match($course,'([A-Z])(\d+)')
            $obj=[PSCustomObject]@{
                Dir = $dirs.Groups[1].Value
                Steps = $dirs.Groups[2].Value
            }
            return $obj
        }

        function Set-Forward ([int]$steps) {
            switch ($this.face) {
                'E' { $this.x += $steps }
                'W' { $this.x -= $steps }
                'N' { $this.y += $steps }
                'S' { $this.y -= $steps }
            }
        }

        function Set-Rotate ($ins) {
           [int]$noRo=([int]$ins.Steps / 90) % 4
            switch ($ins.Dir) {
                'R' {
                    [int]$mv=[clWise]::($this.face).value__ + $noRo
                    if($mv -gt 4) {
                        [int]$mv=[int]$mv % 4
                    }
                    $this.face=[clWise].GetEnumName($mv)
                }
                'L' {
                    [int]$mv=[aclWise]::($this.face).value__ + $noRo
                    if($mv -gt 4) {
                        [int]$mv=[int]$mv % 4
                    }
                    $this.face=[aclWise].GetEnumName($mv)
                }
            }
        }

        function Move-Direction($ins) {
            switch ($ins.Dir) {
                'E' { $this.x += $ins.Steps }
                'W' { $this.x -= $ins.Steps }
                'N' { $this.y += $ins.Steps }
                'S' { $this.y -= $ins.Steps }
            }
        }

        $where = Get-Course $course
        switch ($where.Dir) {
            'F' { Set-Forward($where.Steps) }
            { $_ -in ('E','W','N','S') } { Move-Direction ($where) }
            { $_ -in ('L','R') } { Set-Rotate ($where) }
        }
    }
}

class Ship2 {

    [int]$x=0
    [int]$y=0
    [int]$rwx=10
    [int]$rwy=1
    [int]$wx=10
    [int]$wy=1

    [void] Move([string]$course) 
    {
        function Get-Course ($course) {
            $dirs=[regex]::Match($course,'([A-Z])(\d+)')
            $obj=[PSCustomObject]@{
                Dir = $dirs.Groups[1].Value
                Steps = $dirs.Groups[2].Value
            }
            return $obj
        }
        function Move-Waypoint() {
            $this.wx = $this.x + $this.rwx
            $this.wy = $this.y + $this.rwy
        }

        function Set-ForwardToWaypoint ([int]$steps) {
            $this.x = $this.x + $this.rwx * $steps
            $this.y = $this.y + $this.rwy * $steps
            Move-Waypoint
        }
        
        function Invoke-WaypointRotation ($ins) {
            [int]$noRo=([int]$ins.Steps / 90) % 4
            [string]$action=$ins.Dir+$noRo
            [int]$t1=$null
            switch ($action) {
                {$_ -eq 'R1' -or $_ -eq 'L3'} {
                    $t1 = $this.rwx 
                    $this.rwx = $this.rwy
                    [int]$this.rwy = (0 - $t1)
                    ## y,-x
                    }
                {$_ -eq 'R2' -or $_ -eq 'L2'} {
                    $this.rwx = (0 - $this.rwx)
                    $this.rwy = (0 - $this.rwy)
                    ## -x,-y
                    }
                {$_ -eq 'R3' -or $_ -eq 'L1'} {
                    $t1 = $this.rwx
                    $this.rwx = (0 - $this.rwy)
                    $this.rwy = $t1
                    ## -y,x
                    }
            }
            Move-Waypoint
        }

        function Move-WaypointRel($ins) {
            switch ($ins.Dir) {
                'E' { $this.rwx += $ins.Steps }
                'W' { $this.rwx -= $ins.Steps }
                'N' { $this.rwy += $ins.Steps }
                'S' { $this.rwy -= $ins.Steps }
            }
            Move-Waypoint
        }

        $where = Get-Course $course
        switch ($where.Dir) {
            'F' { Set-ForwardToWaypoint($where.Steps) }
            { $_ -in ('E','W','N','S') } { Move-WaypointRel ($where) }
            { $_ -in ('L','R') } { Invoke-WaypointRotation($where) }
        }
    }
}

$ship1 = [Ship1]::new()
$ship2 = [Ship2]::new()

$in | ForEach-Object {
   $ship1.move($_)
   $ship2.move($_)

}

$ship1 | Select-Object @{l='Stage #1:';e={ [math]::Abs([long]$_.x) + [math]::Abs([long]$_.y) }} | Out-String
$ship2 | Select-Object @{l='Stage #2:';e={ [math]::Abs([long]$_.x) + [math]::Abs([long]$_.y) }} | Out-String