# Original from https://ravingroo.com/458/active-directory-shadow-group-automatically-add-ou-users-membership/
# Modifications by meoso https://gist.github.com/meoso/301f2e94306dcf2d3714c26ca5518932
# I changed it to go recursively through OUs, so you can specify the top-level OU and it will parse all children.
# DOES NOT APPLY THE LICENSE FILE IN THE ROOT OF THE REPO, AS MUCH OF THIS IS NOT MY CODE.

# Creates OU Shadow Groups

$OU="OU=Students,DC=example,DC=com"
$ShadowGroup="CN=Students,OU=Students,DC=example,DC=com"

Import-Module ActiveDirectory
(Get-ADGroup -Identity $ShadowGroup -properties members).Members | Get-ADUser | Where-Object {$_.distinguishedName –NotMatch $OU} | ForEach-Object {Remove-ADPrincipalGroupMembership –Identity $_ –MemberOf $ShadowGroup –Confirm:$false}
Get-ADUser –SearchBase $OU –SearchScope OneLevel –LDAPFilter "(!memberOf=$ShadowGroup)" | ForEach-Object {Add-ADPrincipalGroupMembership –Identity $_ –MemberOf $ShadowGroup}
