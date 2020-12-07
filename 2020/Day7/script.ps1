#in progress


$in = Get-Content $PSScriptRoot/input
$t=[System.Collections.ArrayList]@()
$b=[System.Collections.ArrayList]@()


$in | ForEach-Object {

    $outPatt = '^(.*) bags contain ((\d+|no).*bag.*).$'
    $searchOuter=[regex]::Matches($_,$outPatt)
    $outBag=$searchOuter.Groups[1].Value
    $innerBags=$searchOuter.Groups[2].Value.split(",")

    $InnerBags | ForEach-Object {
        $inPatt = '^(\d+|no) (.*) bag|s$'
        $searchInner=[regex]::Matches($_.trim(),$inPatt)
        $innerQnt=$searchInner.Groups[1].Value
        $innerClr=$searchInner.Groups[2].Value
        if ($innerQnt -eq 'no') {
            $innerQnt = 0
            $innerClr = $null
        }

        $t.Add([PSCustomObject]@{
            Color = $outBag
            InnerColor = $innerClr
            InnerNo = [int]$innerQnt
            LastColor = $null

        }) | Out-null

    }

}
#$t 
#Write-Output '--------'
[int]$outCount=0
($t | Group-Object -Property Color) | ForEach-Object {
    #Write-Output "========"
    $outerColor=$_.Name
    #Write-Output "outerColor: $outerColor"
    #Write-Output "------"
    #Write-Output "------"
    $innerColor=$_.Group.InnerColor
    #Write-Output "inColors: $innerColor"
    #Write-Output "------"
    foreach ($inner in $innerColor) {

        #Write-Output "currentInner: $inner"
        $nx=$t | Where-Object {$_.Color -eq $inner} | Select-Object -expandProperty InnerColor
        #Write-Output "nextColor1: $nx"
        foreach ($inx in $nx) {
            while ($null -ne $inx -and $inx -ne 'shiny gold')
            {
                $inner = $inx
                #rite-Output "current inx:: $inx"
                $inx=$t | Where-Object {$_.Color -eq $inner} | Select-Object -expandProperty InnerColor
            }
            if($null -eq $inx) {
                #Write-Output "Found nxcolor to be null"
                #Write-Output "nextColor: $inx"
            }
            elseif ($inx -eq 'shiny gold') {
                #Write-Output "Found nxcolor to be shiny gold"
                $t | Where-Object {$_.Color -eq $outerColor} | ForEach-Object {$_.LastColor = $inx }
                #Write-Output "nextColor: $inx"
                #break
            
            }
            #Write-Output "------"
        }
        #Pause
    }
    
    #Write-Output "========"
}
        
    
    # #$innerColor | ForEach-Object {
        
    #     $currentInner = $inner
    #     Write-Output "current innerColor: $currentInner"
    #     $nextColor=$t | Where-Object {$_.Color -eq $currentInner} | Select-Object -expandProperty InnerColor
    #     Write-Output "nextColor: $nextColor"
    #     foreach ($nx in $nextColor) {
    #         Write-Output "nx: $nx"
    #         while ($null -ne $nx -and $nx -ne 'shiny gold') {
    #             $currentInner = $nx
    #             $nx=$t | Where-Object {$_.Color -eq $currentInner} | Select-Object -expandProperty InnerColor
    #         }
    #         if($null -eq $nx) {
    #             Write-Output "Found nxcolor to be null"
    #             Write-Output "nextColor: $nx"
    #         }
    #         elseif ($nx -eq 'shiny gold') {
    #             Write-Output "Found nxcolor to be shiny gold"
    #             Write-Output "nextColor: $nx"
    #         }

    #     }
    #     #$t | Where-Object {$_.Color -eq $outerColor} | ForEach-Object {$_.LastColor = $nx }
    #     Write-Output "----------"
    #     #break 
    # }
    # Write-Output "=========="
    # $outCount++
#}
#Write-Output "END=========="

$st = $t | Where-Object {$_.InnerColor -eq 'shiny gold' -or $_.LastColor -eq 'shiny gold'} | Select-Object -Property Color -Unique

$st
$st.Count 




# [int]$clrCount=0
# $outerBag=$t.BagClr | Select-Object -Unique
# $outerBag | ForEach-Object {
#     $currentOuter=$_

#     $foundOuter = $t | Where-Object {$_.BagClr -eq $currentOuter -and $_.InnerBagClr  -eq 'shiny gold'}
#     # if ($foundOuter.BagClr.Count -gt 0)
#     # {
#     #     $t | Where-Object {$_.BagClr -eq $currentOuter} | ForEach-Object {$_.ShinyGold = $true }
#     # }
#     $innerBag = $t | Where-Object BagClr -eq $currentOuter
#     $innerBag.InnerBagClr | ForEach-Object {
#         $currentInner=$_
#         # $found = $t | Where-Object {$_.BagClr -eq $currentInner -and $_.InnerBagClr  -eq 'shiny gold'}
#         # if ($found.BagClr.Count -gt 0)
#         # {
#         #     $t | Where-Object {$_.BagClr -eq $currentOuter} | ForEach-Object {$_.ShinyGold = $true }
#         # }
#     }
#     $clrCount++
# }

# #$colors = $t | Where-Object ShinyGold -eq 'True' | Select-Object -Property bagClr -Unique




# #.. to be continue


