Class Cord {
    [int]$x=0
    [int]$y=0
    $t=[System.Collections.ArrayList]@()

    Cord() {
        $this.t.Add([PSCustomObject]@{
            X = $this.x
            Y = $this.y
            P = 1
            }) | Out-Null

    }
    [void] Move([string]$s) {
        switch ($s) {
            "<" {$this.x--}
            ">" {$this.x++}
            "v" {$this.y--}
            "^" {$this.y++}
        }
        $this.t.Add([PSCustomObject]@{
            X = $this.x
            Y = $this.y
            P = 1
            }) | Out-Null
    }
}

$in = Get-content $PSScriptRoot/input
$c1=[Cord]::new()
$c2=[Cord]::new()
$c3=[Cord]::new()
$in.ToCharArray() | ForEach-Object {
        $c1.Move($_)
}

#stage 2
for($i=0;$i -le $in.Length; $i++) {
    if($i % 2 -eq 0) {
        $c2.Move($in[$i])
    }
    else {
        $c3.Move($in[$i])
    }
}

$st1=(($c1.t | Group-Object X,Y) | Where-object {$_.Count -ge 0}).Count
$st2=(($c2.t + $c3.t | Group-Object X,Y) | Where-object {$_.Count -ge 0}).Count

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"