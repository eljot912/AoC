$in = (((Get-Content $PSScriptRoot/input) -join " ") -split "  ").replace(" ",";")
$q=[System.Collections.ArrayList]@()
[int]$g = 1
[string]$gline=$null
$in | ForEach-Object {
    $gr=$_.split(";") 
    $gr | ForEach-Object { $gline+=$_ }
    $cSearch=$gline.ToCharArray() | Group-Object
    $q.Add([PSCustomObject]@{
        Group = $g
        Members = $gr.Count
        Answer = $gline
        Any = ($cSearch.Name | Select-Object -Unique) -join ""
        Every = ($cSearch | Where-Object {$_.Count -eq $gr.Count}).Name -join ""
    })| Out-Null
    $gline=$null
    $g++
}
$st1=($q | ForEach-Object {$_.Any.length} | Measure-Object -Sum).Sum
$st2=($q | ForEach-Object {$_.Every.length} | Measure-Object -Sum).Sum
Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"
