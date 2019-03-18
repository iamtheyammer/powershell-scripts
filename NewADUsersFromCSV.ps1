# Written by iamtheyammer, MIT license
# This expects output from a gam command with allfields.
# Example: gam print users allfields query:"orgUnitPath:'/Students'"
# SKIPS OVER SUSPENDED USERS!!!!!
# CREATED DISABLED USERS!!!!!!!!!

$users = Import-Csv -Path "C:\some.csv"

foreach($user in $users) {
    if($user."suspended" -eq "True") {
        "Not creating an account for $($user."name.fullName") because their account is disabled."
        continue
    }

    "Creating an account for $($user."name.fullName")..."
    New-ADUser `
        -Name $user."name.fullName" `
        -Enabled $false `
        -AccountPassword (ConvertTo-SecureString -Force -AsPlainText "pickAPassword") `
        -DisplayName $user."name.fullName" `
        -UserPrincipalName $user."primaryEmail" `
        -ChangePasswordAtLogon $true `
        -EmailAddress $user."primaryEmail" `
        -GivenName $user."name.givenName" `
        -Surname $user."name.familyName" `
        -Path "OU=ENTERAN,DC=LDAP,DC=QUERY" `
        -SamAccountName $user."primaryEmail".split('@')[0]
    # for some reason the above command doesn't force a password change so we do it here
    Set-ADUser `
        -Identity $user."primaryEmail".split('@')[0] `
        -ChangePasswordAtLogon $true `
        -ProfilePath "OU=ENTERTHESAME,OU=LDAP,DC=QUERY,DC=ASABOVE"
    "Account created for $($user."name.fullName")."
}
