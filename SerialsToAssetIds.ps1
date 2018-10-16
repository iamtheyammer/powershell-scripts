# Imports a CSV from headers |assetId|serialnumber|. Then, updates admin console asset IDs.
# Also prints out the number of the row that it's working on so you can see progress.
# MIT License by GitHub/iamtheyammer
$csv = Import-Csv -Path "C:\Users\IT-Master-Lenovo\Downloads\assets.csv"
$ids = $null;
for ($i = 0; $i -lt $csv.Count; $i++) {
    $deviceId = (gam.exe print cros query `"id:$($csv[$i].serialNumber)`" 2> $null).Split("\n")[1] + "`n"
    (gam.exe update cros $($deviceId) assetid $($csv[$i].assetId) 2> $null)
    $i
}
