$inputData = Get-Content .\input
$dataCount = $inputData.Count
$result=[System.Collections.ArrayList]@()
for ($i = 0; $i -lt $dataCount; $i++) {
    $firstValue=$inputData[$i]
    for ($j = 0; $j -lt $dataCount; $j++)
    {
        $secondValue=$inputData[$j]
        if ($firstValue -ne $secondValue)
        {
            [int]$additionResult=[int]$firstValue + [int]$secondValue
            if ($additionResult -eq 2020)
            {
                $result.Add([PSCustomObject]@{
                    DataSet = "[$firstValue,$secondValue]"
                    Addition = $additionResult
                    Multiply = [int]$firstValue * [int]$secondValue
                }) | Out-Null
            }
            for ($k = 0; $k -lt $dataCount; $k++)
            {
                $thirdValue=$inputData[$k]
                if ($firstValue -ne $thirdValue)
                {
                    [int]$additionResult=[int]$firstValue + [int]$secondValue + [int]$thirdValue
                    if ($additionResult -eq 2020)
                    {
                        $result.Add([PSCustomObject]@{
                            DataSet = "[$firstValue,$secondValue,$thirdValue]"
                            Addition = $additionResult
                            Multiply = [int]$firstValue * [int]$secondValue * [int]$thirdValue
                        }) | Out-Null
                    }
                }
            }
        }
    }
}
$result | Sort-Object Multiply
