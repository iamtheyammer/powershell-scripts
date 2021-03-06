Function Get-DeviceId {
    if(!$args[0]) {return "fail, not enough params. Get-DeviceId <serialNumber>."}
    return (gam.exe print cros query "id:$($args[0])" 2> $null).Split("\n")[1];
}

$deviceId = (Read-Host "Update a Chrome OS device. Enter a serial number...").Split(",");
if($deviceId[1]) {
    $option[0] = $deviceId[1];
    $deviceId = $deviceId[0];
}
$deviceId = Get-DeviceId $deviceId;
if(!$deviceId) {
    return "Could not find that device.";
}
if(-Not $option) {
    "Found device. Select:";
    $option = (Read-Host "get in(f)o | set (l)ocation | set (a)sset id | change (u)ser | d(i)sable | (r)eenable | (c)hange ou | (d)eprovision | (n)ote | (g)et device id").Split(",");
} 

switch($option[0].ToLower()) {
    "f" {
        gam.exe info cros $deviceId full;
    }
    "l" {
        $newLocation = Read-Host "What would you like the new location to be?";
        $done = gam.exe update cros $deviceId location "$($newLocation)";
        "Cool, done!"
    }
    "a" {
        $newAssetId = Read-Host "What would you like the new asset id to be?";
        $done = gam.exe update cros $deviceId assetid "$($newAssetId)";
        "Cool, done!"
    }
    "u" {
        $newUser = Read-Host "Who to move the device to? Do not include the @domain.com.";
        $done = gam.exe update cros $deviceId user $newUser;
        "Cool, done."
    }
    "i" {
        $done = gam.exe update cros $deviceId action disable;
        "Cool, done!"
    }
    "r" {
        $done = gam.exe update cros $deviceId action reenable;
        "Cool, done!"
    }
    "c" {
        $newOu = Read-Host "Enter the new OU path, with no beginning or trailing slash, like Students/OU1"
        "Below is the output from GAM, in case there's an error:`n"
        gam.exe update cros $deviceId ou "$($newOu)";
        "`nIf there's no error, we're done here."
    }
    "d" {
        $depAction = Read-Host "(s)ame model replacement | (d)ifferent model replacement | (r)etiring device";
        if(-Not $depAction) {return "Invalid selection."}
        switch($depAction) {
            "s" {$depAction = "deprovision_same_model_replace"}
            "d" {$depAction = "deprovision_different_model_replace"}
            "r" {$depAction = "deprovision_retiring_device"}
        }
        $depResponse = (gam.exe update cros $deviceId $depAction acknowledge_device_touch_requirement 2> $null);
        $depResponse;
        "Cool, done!";
    }
    "n" {
        "Checking for a note...";
        $note = ((gam.exe info cros $deviceId fields notes) -split "notes: ")[2];
        if(-not $note) {
            $newNote = Read-Host "No note found for this device. Add one by typing and pressing enter or just press enter to exit.";
            if(-not $newNote) {return;}
            (gam.exe update cros $deviceId notes "$($newNote)" 2> $null);
        } else {
            "Here's the note on this device:`n`n$($note)`n";
            $option = Read-Host "(r)eplace | (a)ppend | (s)top"
            switch($option) {
                "r" {
                    $newNote = Read-Host "What would you like the note to say?"
                    if(-not $newNote) {return "Gotcha, I'll just stop then. (you entered nothing!)";}
                    $newnote = (gam.exe update cros $deviceId notes "$($newNote)" 2> $null);
                    return "Cool, done!";
                }
                "a" {
                    $newNote = Read-Host "What would you like to append to the note?"
                    if(-not $newNote) {return "Gotcha, I'll just stop then. (you entered nothing!)";}
                    $newNote = (gam.exe update cros $deviceId notes "$($note) $($newNote)" 2> $null);
                    return "Cool, done!";
                }
                "s" {
                    return;
                }
            } 
        }
    }
    "g" {
        $deviceId;
    }
}