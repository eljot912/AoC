$ErrorActionPreference = 'Stop'
$in = Get-Content $PSScriptRoot/input -Raw
$tValidNumbers=[System.Collections.ArrayList]@()
$hFieldRanges=@{}
$tRanges=[System.Collections.ArrayList]@()
$hTickets=@{}
$hFieldsMatch=@{}
$hValid=@{}
$hFinalList=@{}
[long]$st1=0

$ticketFields=[regex]::Matches($in,'(.*):.(\d+-\d+).(?:or).(\d+-\d+)','Multiline')
$ticketFields | ForEach-Object {
    $tRanges.Clear()
    $field=$_.Groups[1].Value
    $dRange1=$_.Groups[2].Value.split("-")
    $dRange2=$_.Groups[3].Value.split("-")
    $dRange1[0]..$dRange1[1] | ForEach-Object {
        $tRanges.Add($_) | Out-Null
        $tValidNumbers.Add($_) | Out-Null
    }
    $dRange2[0]..$dRange2[1] | ForEach-Object {
        $tRanges.Add($_) | Out-Null
        $tValidNumbers.Add($_) | Out-Null
    }
    $hFieldRanges["$field"] = @($tRanges)
}

#stage #1
$otherLines=[regex]::Matches($in,'nearby tickets:\s(?:.*\s|.)+')
$otherTickets=[regex]::Matches($otherLines.Value,'\d+.*\d+')
[int]$validTicketCount=1
$otherTickets.Value.split(" ") | ForEach-Object {
    $validTicket=$true
    $t=$_.split(",")
    for ($i = 0; $i -lt $t.Count; $i++) {

        if ($t[$i] -notin $tValidNumbers) {
            $st1+=$t[$i]
            $validTicket=$false
        }
    }
    if ($validTicket) {
        $hValid["$validTicketCount"] = $t
        $validTicketCount++
    }
}
Write-Output "Stage #1: -> $st1"

#stage #2
$myticket=[regex]::Matches($in,'your ticket:\s*(.*)','Multiline')
$mTicket=$myticket.Groups[1].Value.trim().split(",")
$mfields=$mTicket.Count

for ($m = 0; $m -lt $mfields; $m++) {
    $hTickets["$m"]=$mTicket[$m]
}

foreach ($fields in $hValid.GetEnumerator()) {
$yfields=$fields.Value
    for ($y = 0; $y -lt $yfields.Count; $y++) {
        $hTickets["$y"]=$hTickets["$y"] + ";" + $yfields[$y]
    }
}

$ttemp=[System.Collections.ArrayList]@()
foreach ($fields in $hTickets.GetEnumerator())
{
    $ticketFieldsValues=$fields.Value.split(";") # | ft
    $ticketFieldsValuesCount = ($ticketFieldsValues | Select-object -Unique).Count

    foreach ($allowedRange in $hFieldRanges.GetEnumerator()) {
        $ticketAllowedRanges=$allowedRange.Value
        $compareCount = (compare-object $ticketFieldsValues $ticketAllowedRanges  -IncludeEqual -excludedifferent -PassThru).Count
        if ($ticketFieldsValuesCount -eq  $compareCount) {
            $ttemp.Add($allowedRange.Name) | Out-Null
        }
    }
    $hFieldsMatch["$($fields.Name)"] = [System.Collections.ArrayList]@($ttemp)
    $ttemp.Clear()
}

$hFieldsMatchTemp=@{}
while ($hFinalList.count -ne $mfields) {
    $oneFieldMatch=$hFieldsMatch.GetEnumerator() | Where-Object {($_.Value).Count -eq 1}
    if ($oneFieldMatch) {
        $hFinalList["$($oneFieldMatch.Name)"] = $oneFieldMatch.Value[0]
    }
    $hFieldsMatch.Remove("$($oneFieldMatch.Name)")
    foreach ($object in $hFieldsMatch.GetEnumerator()) {
        if ($oneFieldMatch.Value[0] -in $object.Value){
            $hFieldsMatchTemp["$($object.Name)"]=@($object.Value | Where-Object {$_ -ne $oneFieldMatch.Value[0]})
        }
    }
    $hFieldsMatch=$hFieldsMatchTemp.Clone()
    $hFieldsMatchTemp.Clear()
}

$myDepartureFields=$hFinalList.GetEnumerator() | Where-Object Value -match 'departure'
[long]$st2=1
$myDepartureFields.Name | ForEach-Object {
    $st2*=$mTicket[$_]
}
Write-Output "Stage #2: -> $st2"
