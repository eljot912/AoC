$in = Get-Content $PSScriptRoot/input
$dataCount = $in.Count
$t=[System.Collections.ArrayList]@()
for ($i = 0; $i -lt $dataCount; $i++) {
    $fV=$in[$i]
    if ($t.Set -contains 3 -and $t.Set -contains 2) {break}
    for ($j = 0; $j -lt $dataCount; $j++)
    {
        $sV=$in[$j]
        if ($fV -ne $sV)
        {
            [int]$aR=[int]$fV + [int]$sV
            if ($aR -eq 2020)
            {
                $t.Add([PSCustomObject]@{
                    DataSet = "[$fV,$sV]"
                    Addition = $aR
                    Multiply = [int]$fV * [int]$sV
                    Set = 2
                }) | Out-Null
            }
            if ($t.Set -notcontains 3) {
                for ($k = 0; $k -lt $dataCount; $k++)
                {
                    $tV=$in[$k]
                    if ($fV -ne $tV)
                    {
                        [int]$aR=[int]$fV + [int]$sV + [int]$tV
                        if ($aR -eq 2020)
                        {
                            $t.Add([PSCustomObject]@{
                                DataSet = "[$fV,$sV,$tV]"
                                Addition = $aR
                                Multiply = [int]$fV * [int]$sV * [int]$tV
                                Set = 3
                            }) | Out-Null
                        }
                    }
                }
            }
        }
    }
}
$t | Sort-Object Multiply
