#Script only does distrobution lists

#Connect to exchange with privileged account
Connect-ExchangeOnline -UserPrincipalName username@contoso.com

#SourceUser is the user you want to copy. TargetUser is the new user.
$sourceUser = "username@contoso.com"
$targetUser = "username@contoso.com"

# Get all distribution groups the source user is a member of
$distributionGroups = Get-DistributionGroup | Where-Object {
    (Get-DistributionGroupMember -Identity $_.Identity | Where-Object { $_.PrimarySmtpAddress -eq $sourceUser }) -ne $null
}

# Add the target user to each distribution group
foreach ($group in $distributionGroups) {
    Add-DistributionGroupMember -Identity $group.Identity -Member $targetUser
}

