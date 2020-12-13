$in = Get-Content $PSScriptRoot/input
$t=[System.Collections.ArrayList]@()
$st1=0
$st2=0
$in | ForEach-Object {
    $l = $_.split(" ")
    $t.Add([PSCustomObject]@{
        LowerCount = $l.split("-")[0]
        UpperCount = $l.split("-")[1]
        Char = $l[1][0]
        Password = $l[2]
    }) | Out-null
}
$t | ForEach-Object {
    $sc=$_.Char
    $ps = $_.Password.ToCharArray()
    $c = ($ps | Where-Object {$_ -eq $sc} | Measure-Object).Count
    if($c -ge $_.LowerCount -and $c -le $_.UpperCount) {
        $st1++
    }
    if (($ps[$_.LowerCount-1] -eq $sc) -xor ($ps[$_.UpperCount-1] -eq $sc)) {
        $st2++
    }    
}
Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"
