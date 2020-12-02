$inputData = Get-Content .\input
$result=[System.Collections.ArrayList]@()
$oldPolicyCount=0
$newPolicyCount=0
$inputData | ForEach-Object {

    $line = $_.split(" ")
    $result.Add([PSCustomObject]@{
        LowerCount = $line.split("-")[0]
        UpperCount = $line.split("-")[1]
        Char = $line[1][0]
        Password = $line[2]
    }) | Out-null
    
}
$result | ForEach-Object {
    $searchChar=$_.Char
    $charPassword = $_.Password.ToCharArray()
    $count = ($charPassword | Where-Object {$_ -eq $searchChar} | Measure-Object).Count
    if($count -ge $_.LowerCount -and $count -le $_.UpperCount)
    {
        $oldPolicyCount++

    }
    if (($charPassword[$_.LowerCount-1] -eq $searchChar) -xor ($charPassword[$_.UpperCount-1] -eq $searchChar))
    {
        $newPolicyCount++
    }    
}
Write-Output "Valid Passwords - old Policy: $oldPolicyCount | new Policy: $newPolicyCount"
