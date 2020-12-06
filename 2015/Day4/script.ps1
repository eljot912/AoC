param (
    [int]
    $start
)
[string]$in='bgvyzdsv'
[int]$i=$start
while(!$f)
{
    $b = [System.Text.Encoding]::UTF8.GetBytes($in+$i)
    $a = [System.Security.Cryptography.HashAlgorithm]::Create('MD5')
    $s = New-Object System.Text.StringBuilder
    $a.ComputeHash($b) | 
    ForEach-Object { 
        $null = $S.Append($_.ToString("x2")) 
    } 
    $md5=$s.ToString()
    if($md5 -match '^[0]{6}.*$') {$i;$md5;$f=$true}
    $i++
}