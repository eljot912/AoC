$ErrorActionPreference='Stop'
$in = Get-Content $PSScriptRoot/input
$t=[System.Collections.ArrayList]@()
$c=[System.Collections.ArrayList]@()
$hBags = @{}
$bagSearch='shiny gold'

function Get-Data() {

    $in | ForEach-Object {
        $outPatt = '^(.*) bags contain ((\d+|no).*bag.*).$'
        $searchOuter=[regex]::Matches($_,$outPatt)
        $outBag=$searchOuter.Groups[1].Value
        
        $innerBags=$searchOuter.Groups[2].Value.split(",").trim()
        $InnerBags | ForEach-Object {
             $inPatt = '^(\d+|no) (.*) bag|s$'
             $searchInner=[regex]::Matches($_,$inPatt)
             $innerQnt=$searchInner.Groups[1].Value
             $innerClr=$searchInner.Groups[2].Value
            if ($innerQnt -ne 'no') {
                $script:t.Add("$innerClr,$innerQnt") | Out-Null
             }
        }
        $script:hBags.Add($outBag,$t -join ";")
        $script:t.Clear()
    }
}

function Measure-Bags()
{
    foreach ($bag in $hBags.Keys)
    {
         RecurseBag($bag)
    }
}

function RecurseBag($key)
{
    if ([string]::IsNullOrEmpty($hBags[$key])) {
        #do nothing
    }
    elseif ($hBags[$key] -match 'shiny gold') {
        $c.Add($bag) | Out-Null
    }
    else 
    {
        foreach ( $inner in $hBags[$key].split(";")) {
           RecurseBag($inner.split(",")[0])
        }
    }
}

function Add-Bags($key)
{
    if ([string]::IsNullOrEmpty($hBags[$key])) {
        #do nothing
    }
    else {
        [int]$intCount=0
        foreach ( $inner in $hBags[$key].split(";")) {
            $noB=[int]$inner.split(",")[1]
            $bagColor=$inner.split(",")[0]
            $intCount+= $noB + $noB* (Add-Bags($bagColor))
        }
        return $intCount
   }
}

Get-Data
Measure-Bags
$st1=($c | Select-Object -Unique).Count
$st2 = Add-Bags($bagSearch)
Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"
