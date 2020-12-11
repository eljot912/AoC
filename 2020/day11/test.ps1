### refactor needed


$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input
$t=[System.Collections.ArrayList]@()
$t1=[System.Collections.ArrayList]@()

$in
$lno=$in.Count

for ($x=0;$x -lt $lno;$x++ ) {

    $line=$in[$x].ToCharArray()
    $cNo=$line.Count
    for ($y = 0; $y -lt $cno;$y++) {
        $t.Add([PSCustomObject]@{
            X = $x
            Y = $y
            Seat = $line[$y]
        }) | Out-Null
        #Write-Output "$x,$y -> $($line[$y])"
    } 
    
}
$poSeats=($t | Where-Object Seat -eq '#').Count
Write-Output "Occupied seats: $poSeats"
$coSeats = $null

while ($poSeats -ne $coSeats) {
        Write-Output "Entering round| Current: $coSeats, Previous: $poSeats"
        $poSeats = $coSeats
        #$t1=$t
        [int]$count=0
        foreach ($seat in $t) {
            Write-Output "$count / $($t.Count)"
            #do smth
            $cX=$seat.X
            $cY=$seat.Y
            $cSeat=$seat.Seat
            $pX=[int]$cx-1
            $nX=[int]$cx+1
            $y1=[int]$cY-1
            $y2=[int]$cy+1
            #$seat
            $aSeats=$t | Where-Object {
                ($_.X -eq $px -and $_.Y -in ($y1,$cy,$y2))`
                -or ($_.X -eq $cx -and $_.Y -in ($y1,$y2))`
                -or ($_.X -eq $nx -and $_.Y -in ($y1,$cy,$y2))`
            }
            $oaSeats=($aSeats | Where-Object {$_.Seat -eq '#'}).Count
            #Write-Output "Current: [$cx,$cy]`n-----"
#            sleep 5
 #           Pause
            if( $cSeat -eq 'L' -and $oaSeats -eq 0)
            {
                #Write-Output "Marking Seat as occupied at $"
                $t1.Add([PSCustomObject]@{
                    X = $cx
                    Y = $cy
                    Seat = '#'
                }) | Out-Null
                #$seat.Updated = '#'
            }
            elseif ($cSeat -eq '#' -and $oaSeats -ge 4) {
                ##Write-Output "Marking Seat as vacant"
                $t1.Add([PSCustomObject]@{
                    X = $cx
                    Y = $cy
                    Seat = 'L'
                }) | Out-Null
                #$seat.Updated ='L'
            }
            else {
                #$seat.Updated = $seat.Seat
                $t1.Add([PSCustomObject]@{
                    X = $cx
                    Y = $cy
                    Seat = $cSeat
                }) | Out-null
            }


            #$pY=$pY
            #Write-Output "$current [$cX,$cY]`n-----------"
            #sleep 1
            #Pause
            $count++
            #$t1
            #Pause
        }
        
        $t.Clear()
        $t=$t1.Clone()
        #$t
        #sleep 1
        #Pause
        #$t
        $t1.Clear()
        $coSeats=($t | Where-Object Seat -eq '#').Count
        Write-Output "Ending round| Current: $coSeats, Previous: $poSeats"
        Write-Output "================"
        $line=$null
        $max=($t | Measure-Object X,Y -Maximum).Maximum


        for ($x = 0; $x -le $max[0]; $x++) {
            for ($y = 0; $y -le $max[1];$y++) {
                #Write-Output "$x,$y"
                $line+=$t | Where-Object {$_.X -eq $x -and $_.Y -eq $Y} | Select-Object -ExpandProperty Seat
            }
            Write-Output "$line"
            $line=$null
              
        }
        
             






        #Sleep 2
        #Pause
}




Write-Output "----------------"
$oSeats=($t | Where-Object Seat -eq '#').Count

Write-Output "Occupied seats: $oSeats"
