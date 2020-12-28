$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input
$hRules=@{}
$hMessage=@{}
$tParse=[System.Collections.ArrayList]@()
$sParse=[System.Collections.ArrayList]@()
$in | ForEach-Object {
    switch -regex ($_) {
        '^(\d+):\s(.*)' {
            $resultStr=$Matches
            if ($Matches[2] -match '"') {
                $hRules[[int]$resultStr[1]] = [string]$resultStr[2].replace('"','')
            }
            else {
                $alternative=$resultStr[2].replace(' | ','|').split("|")
                $tParse.Clear()
                foreach ($alt in $alternative) {
                    $sParse.Clear()
                    foreach ($sub in $alt.split(" ")) {
                        $sParse.Add($sub) | Out-Null
                    }
                    $tParse.Add($sParse.Clone()) | Out-Null
                }
                $hRules[[int]$resultStr[1]] = $tParse.Clone()
                $tParse.Clear()
            }
        }
        '^([ab]+)' { $hMessage["$($Matches[1])"] = $Matches[1]}
    }
}

function Search-Rules ([int]$rule) {
    $value=$hRules[$rule]
    if ($value -in @('a','b')) { 
        return $value
    }
    $t1=[System.Collections.ArrayList]@()
    $t1.Clear()
    foreach ($item in $value) {
        $result=''
        foreach ($subItem in $item.split(" ")) {
            $result+=Search-Rules $subItem
        }
        $t1.Add($result) | Out-Null
    }
    return "(" + ( $t1 -join("|") ) + ')'
}

function Search-ExtendedRules ([int]$rule) {
    $value=$hRules[$rule]
    if ($rule -eq 8) {
        return "(" + (Search-ExtendedRules 42) + ')+'
    }
    elseif ($rule -eq 11) {
        $x=Search-ExtendedRules 42
        $z=Search-ExtendedRules 31
        $t1=[System.Collections.ArrayList]@()
        $t1.Clear()
        1..50 | ForEach-Object {
            $t1.Add("$x{$_}$z{$_}") | Out-Null
        }
        return "(" + ( $t1 -join("|") ) + ')'
    }
    elseif($value -in @('a','b')) { 
        return $value
    }
    else {
        $t1=[System.Collections.ArrayList]@()
        $t1.Clear()
        foreach ($item in $value) {
            $result=''
            foreach ($subItem in $item.split(" ")) {
                $result+=Search-ExtendedRules $subItem
            }
            $t1.Add($result) | Out-Null
        }
        return "(" + ( $t1 -join("|") ) + ')'
    }
}

$res="^$(Search-Rules 0)$"
foreach ($item in $hMessage.Keys) {
    $st1+=[bool][regex]::Matches($item,$res)
   
}

$res="^$(Search-ExtendedRules 0)$"
foreach ($item in $hMessage.Keys) {
     $st2+=[bool][regex]::Matches($item,$res)
    
}

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"