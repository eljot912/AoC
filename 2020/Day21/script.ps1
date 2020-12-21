$ErrorActionPreference = 'Stop'
$hAlg=@{}
$hAlgNew=@{}
$hProd=@{}
$tAllProd=[System.Collections.ArrayList]@()
$in = Get-Content $PSScriptRoot/input -Raw
$inrgx = [regex]::Matches($in,'^(.*)\(contains\s(.*)\)','Multiline')
$inrgx | ForEach-Object {
    $alg = $_.Groups[2].Value.split(",").trim()
    $prod = $_.Groups[1].Value.trim().split(" ")
    $prod  | ForEach-Object {
            $tAllProd.Add($_) | Out-Null

    }
    $alg | ForEach-Object {
        $cAlg=$_.trim()
        if ($null -eq $hAlg.$cAlg) {
            $prod = $prod | Where-Object {$_ -notin $hProd.Keys}
            if ($prod.count -eq 1) {
                $hProd.$prod = $cAlg
            }
            $hAlg.$cAlg = $prod
        }
        else {
            $prod = $prod | Where-Object {$_ -notin $hProd.Keys}
            $matchingProd=Compare-Object $hAlg.$cAlg $prod -IncludeEqual -ExcludeDifferent -PassThru
            if ($matchingProd.count -eq 1) {
                $hProd.$matchingProd = $cAlg
                $hAlg.$cAlg = $matchingProd
                $hAlgNew=$hAlg.Clone()
                foreach ($item in $hAlg.GetEnumerator() )
                {
                    if ($item.Name -ne $cAlg ) {
                        if ($item.Value -contains "$matchingProd") {
                        $updatedValue=$hAlg["$($item.Name)"] | Where-Object {$_ -ne $matchingProd}
                            if ($updatedValue.count -eq 1) {
                                $hProd.$updatedValue = $item.Name
                            }
                            $hAlgNew["$($item.Name)"] = $updatedValue
                        }
                    }
                }
                $hAlg=$hAlgNew.Clone()
                $hAlgNew.Clear()
            }
            else {
                $hAlg.$cAlg = $matchingProd
            }
        }
    }
}
$st1=($tAllProd | Group-Object | Where-Object {$_.Name -notin $hProd.Keys} | Measure-Object Count -Sum).Sum
$st2=($hProd.GetEnumerator() | Sort-Object Value).Name -join ","

Write-Output "Stage #1: -> $st1 | Stage #2: -> $st2"
