$dataInput = Get-Content $PSScriptRoot/input
[string]$passportSet=''
$passFields=[System.Collections.ArrayList]@()
[int]$vC1=0
[int]$vC2=0

function Validation([string]$pIn)
{
    $fTable=$pIn.split("")
    $fTable | ForEach-Object {
        $name=$_.split(":")[0]
        $value=$_.split(":")[1]
        if ($name -ne 'cid')
        {
            $passFields.Add([PSCustomObject]@{
                Name = $name
                Value = $value
                Passed = $null
            }) | Out-null
        }
    }
    
    #stage1 check
    $rf = @("byr","iyr","eyr","hgt","hcl","ecl","pid")
    $pf = $rf | Where-Object {$_ -in $passFields.Name}
    if ($pf.Count -eq $rf.Count) { 
        $script:vC1++

        #stage2 check
        $passFields | ForEach-Object {
            $cf=$_
            switch ($_.Name) {
                "byr" {
                    $sr=[regex]::Matches($cf.Value,'^\d{4}$').Value
                    if($sr -ge 1920 -and $sr -le 2002) {$cf.Passed=$true }
                }
                "iyr" { 
                    $sr=[regex]::Matches($cf.Value,'^\d{4}$').Value
                    if($sr -ge 2010 -and $sr -le 2020) {$cf.Passed=$true}
                }
                "eyr" { 
                    $sr=[regex]::Matches($cf.Value,'^\d{4}$').Value
                    if($sr -ge 2020 -and $sr -le 2030) {$cf.Passed=$true}
                }
                "hgt" {
                    $sr=[regex]::Matches($cf.Value,'^(\d+)(cm|in)$')
                    if(![string]::IsNullOrEmpty($sr)) {
                        $sr2=$sr.Groups[2].Value
                        $sr3=$sr.Groups[1].value
                        switch ($sr2) {
                            "cm" { if($sr3 -ge 150 -and $sr3 -le 193) {$cf.Passed=$true}}
                            "in" { if($sr3 -ge 59 -and $sr3 -le 76) {$cf.Passed=$true}}
                        }
                    }
                }
                "hcl" { if ($cf.Value -match '^#[0-9a-f]{6}$') {$cf.Passed=$true}}
                "ecl" { if ($cf.Value -match '^\bamb\b|\bblu\b|\bbrn\b|\bgry\b|\bgrn\b|\bhzl\b|\both\b$') {$cf.Passed=$true}}
                "pid" { if ($cf.Value -match '^\d{9}$')  {$cf.Passed=$true}}
            }
        }
    }

    $lc=$passFields | Where-Object {$_.Passed -eq "True"}
    if($lc.Count -eq  $passFields.Count) { $script:vC2++ }
    $passFields.Clear()
}

for ($i = 0; $i -le $dataInput.Count; $i++) {
    if($dataInput[$i] -eq "" -or $i -eq $dataInput.Count)
    {
        if (![string]::IsNullOrEmpty($passportSet)) {
            Validation($passportSet.trim())
        }
        $passportSet=''
    }
    else {
        $passportSet+="$($dataInput[$i]) "
    }
}
Write-Output "Valid Count Stage #1: -> $vC1 | Stage #2: -> $vc2"