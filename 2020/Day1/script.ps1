$in = Get-Content $PSScriptRoot/input
$dataCount = $in.Count
[int]$eq=$null
$t=[System.Collections.ArrayList]@()
[bool]$bst1=$false
[bool]$bst2=$false
:outer for ($i = 0; $i -lt $dataCount; $i++) {
    [int]$fv=$in[$i]
    for ($j = 0; $j -lt $dataCount; $j++) {
        [int]$sv=$in[$j]
        if ($fv -ne $sv)
        {
            [int]$eq = 2020 - $fv - $sv
            if ($eq -eq 0)
            {
                $t.Add([PSCustomObject]@{
                DataSet = "[$fv,$sv]"
                Addition = 2020
                Multiply = [int]($fv * $sv)
                Set = 2
                }) | Out-Null
                $bst1=$true
                if ($bst2) { break outer}
            }
            for ($k = 0; $k -lt $dataCount; $k++) {
                [int]$tv=$in[$k]
                if ($fv -ne $tv -and !$bst2)
                {
                    [int]$eq = 2020 - $fv - $sv - $tv
                    if ($eq -eq 0)
                    {
                        $t.Add([PSCustomObject]@{
                        DataSet = "[$fv,$sv,$tv]"
                        Addition = 2020
                        Multiply =[int]($fv * $sv * $tv)
                        Set = 3
                        }) | Out-Null
                        $bst2=$true
                        if ($bst1) { break outer}
                    }
                }
            }
        }
    }
}
$st1 = ($t | Where-Object Set -eq 2).Multiply
$st2 = ($t | Where-Object Set -eq 3).Multiply

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"