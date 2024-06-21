#Runs script with elevated privileges
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'running with full privileges'


#Logoff Times last 24hrs



$XMLLOGOFF=@'
    <QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4647) 
     and 
       TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]
    </Select>
  </Query>
</QueryList>
'@



$XMLLOGON=@'
     <QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624) 
     and 
          TimeCreated[timediff(@SystemTime) &lt;= 86400000]]
     and
      EventData[Data[@Name='TargetUserName']='username']
     ]
</Select>
  </Query>
</QueryList>
'@

# Check if the file exists

$filePath= "C:\new.txt"

    # File exists, only run Get-WinEvent commands without headings
    Write-Output "Logoff Time:" | Out-File $filePath -Append

    Get-WinEvent -FilterXml $XMLLOGOFF | Format-Table -Property TimeCreated -AutoSize | Out-File $filePath -Append

    Write-Output "Logon Time:" | Out-File $filePath -Append

    Get-WinEvent -FilterXml $XMLLOGON | Format-Table -Property TimeCreated -AutoSize | Out-File $filePath -Append

    Write-Output "________________________________________________________________________________" | Out-File $filePath -Append
