$in = Get-Content $PSScriptRoot/input
[int]$st1 = 0
[int]$pos = 1
[int]$st2 = $null 
[bool]$b =$false
foreach ($item in $in.ToCharArray()) 
{
    Switch ($item) {
        "(" { $st1++; break }
        ")" { $st1--; break }
    }
    if($st1 -eq -1 -and !$b )
    {
        $st2=$pos
        $b=$true
    }
    $pos++
}

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"
