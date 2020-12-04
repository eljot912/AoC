$dataInput = Get-Content ./input
[string]$passportSet=''
$passFields=[System.Collections.ArrayList]@()
[int]$vC1=0
[int]$vC2=0

function Validation([string]$pIn)
{
    
    #Write-Output "-> $pIn"
    $fTable=$pIn.split("")
    $fTable | ForEach-Object {
        $name=$_.split(":")[0]
        $value=$_.split(":")[1]
        $passFields.Add([PSCustomObject]@{
            Name = $name
            Value = $value
            Passed = $false
        }) | Out-null
    }
    
    #stage1 check
    $rf = @("byr","iyr","eyr","hgt","hcl","ecl","pid")
    $pf = $rf | Where-Object {$_ -in $passFields.Name}
    if ($pf.Count -eq $rf.Count) { 
        $script:vC1++
    }
    
    #stage2 check
    $passFields | ForEach-Object {
        $cf=$_
        switch ($_.Name) {
            "byr" {
                if ($cf.Value -match '^\d{4}$')
                {
                    if($matches[0] -ge 1920 -and $matches[0] -le 2002) {$cf.Passed=$true }
                }
            }
            "iyr" { 
                if ($cf.Value -match '^\d{4}$')
                {
                    if($matches[0] -ge 2010 -and $matches[0] -le 2020) {$cf.Passed=$true}   
                }
            }
            "eyr" { 
                if ($cf.Value -match '^\d{4}$')
                {
                    if($matches[0] -ge 2020 -or $matches[0] -le 2030) {$cf.Passed=$true}
                }              
            }
            "hgt" { 
                if ($cf.Value -match '^(\d{2,3})(cm|in)$')
                {
                    switch ($matches[2]) {
                        "cm" {
                            if($matches[1] -ge 150 -or $matches[1] -le 193) {$cf.Passed=$true}
                        }
                        "in" {
                            if($matches[1] -ge 59 -or $matches[1] -le 76) {$cf.Passed=$true}
                        }
                    }
                }
            }
            
            "hcl" { if ($cf.Value -match '^#[a-fA-F0-9]{6}$') {$cf.Passed=$true} }
            "ecl" { if ($cf.Value -match '^\bamb\b|\bblu\b|\bbrn\b|\bgry\b|\bgrn\b|\bhzl\b|\both\b$') {$cf.Passed=$true} }
            "pid" { if ($cf.Value -match '^\d{9}$')  {$cf.Passed=$true} }
        }
    }
    #$passFields
    $lc=$passFields | Where-Object {$_.Name -ne 'cid'} | Select-Object -ExpandProperty Passed
    $lc -contains 'False'
    if ([bool]$chk)
    {
        Write-Output '1sz'
        $lc -contains 'True'
        if($lc -contains 'True')
        {
            Write-Output "Adding v2"
            $script:vC2++
        }
    }

    #Pause
    $passFields.Clear()
}

#    $f=($rf | Where-Object {$pIn -match $_}).Count
#    if ($f -eq $rf.Count)
#    {
#        $vfailed=$false
#        $rf | ForEach-Object {
#            switch ($_) {
                # "byr" {
                #     # if ($pIn -match "$_`:(\d{4})")
                #     # {
                #     #     if($matches[1] -lt 1920 -or $matches[1] -gt 2002) {$vfailed = $true;Write-Output "byr CheckFailed"} else  {Write-Output "byr CheckOK" }
                        
                #     # }
                #     # else {
                #     #     #Write-Output "byr CheckOK"
                #     # }
                #     $pIn -match "$_`:(\d{4})" | Out-Null
                #     if ($matches[0] -match'hgt')
                #     {
                #         Write-Output "-> $pIn"
                #         Pause
                #     }
                #     Write-Output $matches[0]

                # }
                # "iyr" { 
                #     if ($pIn -match "$_`:(\d{4})")
                #     {
                #         if($matches[1] -lt 2010 -or $matches[1] -gt 2020) {$vfailed = $true;Write-Output "iyr CheckFailed"} else  {Write-Output "iyr CheckOK" }
                        
                #     }
                #     else {
                #         #Write-Output "iyr CheckOK"
                #     }
                # }
                # "eyr" { 
                #     if ($pIn -match "$_`:(\d{4})")
                #     {
                #         if($matches[1] -lt 2020 -or $matches[1] -gt 2030) {$vfailed = $true;Write-Output "eyr CheckFailed"} else  {Write-Output "eyr CheckOK" }
                        
                #     }
                #     else {
                #         #Write-Output "eyr CheckOK"
                #     }                 
                # }
                #"hgt" { 
                    # if ($pIn -match "$_`:((\d{2,3})(cm|in))")
                    # {
                    #     switch ($matches[3])
                    #     {
                    #         "cm" {
                    #             if($matches[2] -lt 150 -or $matches[2] -gt 193) {$vfailed = $true;Write-Output "hgt CheckFailed"} else {Write-Output "hgt Ok"}
                    #         }
                    #         "in" {
                    #             if($matches[2] -lt 59 -or $matches[2] -gt 76) {$vfailed = $true;Write-Output "hgt CheckFailed"} else {Write-Output "hgt Ok"}
                    #         }
                    #     }
                    # }
                    # else {
                    #     #Write-Output "hgt CheckOK"
                    # }                 

                #}
                
                #"hcl" {
                #     if ($pIn -notmatch "$_`:#([a-fA-F0-9]{6})")
                #     {
                #         $vfailed = $true;
                #         Write-Output "hcl CheckFailed"
                #     }
                #     else {
                #         Write-Output "hcl Ok"
                #     }
                #     if ($pIn -match "$_`:#([0-9a-f]{6})") {
                #         $script:vC2++
                #         Write-Output "-> $pIn"
                #         Write-Output $matches[0]
                #         if ($matches[0] -match 'pid')
                #         {
                #             #$matches[2]
                #             Write-Output "-> $pIn"
                #             Pause
                #         }
                #     }
                # }
               # "ecl" {
                #     if ($pIn -notmatch "$_`:(\bamb\b|\bblu\b|\bbrn\b|\bgry\b|\bgrn\b|\bhzl\b|\both\b)")
                #     {
                #         $vfailed = $true;
                #         Write-Output "ecl CheckFailed"
                #     }
                #     else {
                #         Write-Output "ecl Ok"
                #     }

                #ecl:(amb|blu|brn|gry|grn|hzl|oth)$
                #    if ($pIn -match "$_`:(amb|blu|brn|gry|grn|hzl|oth)") {
                #        $script:vC2++
                        #Write-Output "-> $pIn"
                #        Write-Output $matches[0]
                #         if ($matches[0] -match 'pid')
                #         {
                #             #$matches[2]
                #             Write-Output "-> $pIn"
                #             Pause
                #         }
                #     }

                # }
                # # "pid" { 
                #     if ($pIn -notmatch "$_`:(\d{9})")
                #     {
                #         $vfailed = $true;
                #         Write-Output "pid CheckFailed"
                #     }
                #     else {
                #         Write-Output "pid Ok"
                #     }
    #             # }
    #         }
    #     }
    #     if(!$vfailed)
    #     {
            
    #         #$script:vC2++
    #         #Pause   
    #     }
    #     $script:vC++
    # }
    


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

Write-Output "Valid Count Part 1: $vC1 `nValid Count Part 2: $vc2"
