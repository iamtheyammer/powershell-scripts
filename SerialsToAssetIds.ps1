# Imports a CSV from headers |assetId|serialNumber|. Then, updates admin console asset IDs.
# Make sure to change your paths!
# MIT License by GitHub/iamtheyammer

<# $csv = Import-Csv -Path "C:\Users\IT-Master-Lenovo\Downloads\assets.csv"
$ids = $null;
for ($i = 0; $i -lt $csv.Count; $i++) {
    $deviceId = (gam.exe print cros query `"id:$($csv[$i].serialNumber)`" 2> $null).Split("\n")[1] + "`n"
    (gam.exe update cros $($deviceId) assetid $($csv[$i].assetId) 2> $null)
    $i + 1
}
#>

# This code is functionally identical except it's made for an AssetTiger import: It uses columns |Serial No|Device ID|Asset Tag ID|
$csv = Import-Csv -Path "C:\Users\IT-Master-Lenovo\Downloads\assets.csv"
$ids = $null;
for ($i = 0; $i -lt $csv.Count; $i++) {
    $deviceId = (gam.exe print cros query `"id:$($csv[$i]."Serial No")`" 2> $null).Split("\n")[1] # gets the device ID
    $csv[$i]."Device ID" = $deviceId; # sets the device ID 
    (gam.exe update cros $($deviceId) assetid $($csv[$i]."Asset Tag ID") 2> $null) # sets the asset tag in google
    $i + 1
}


$csv | Export-Csv -Path "C:\Users\IT-Master-Lenovo\Downloads\assets.csv" -NoTypeInformation # exports CSV with device 
