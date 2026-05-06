try {
    $Context.Log("Starting Visual C++ 2012 Redistributable x86 detection")

    if ($null -ne $Context.TargetVersion) {
        $Context.Log("Target version: $($Context.TargetVersion)")
    }

    $RegistryPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{33d1fd90-4274-48a1-9bc1-97e33d9c2d6f}"

    if (Test-Path -Path $RegistryPath) {
        $Props = Get-ItemProperty -Path $RegistryPath -ErrorAction SilentlyContinue
        if ($Props.DisplayVersion) {
            $Context.Log("Found: $($Props.DisplayName) - Version: $($Props.DisplayVersion)")
            return $Props.DisplayVersion
        }
    }

    $Context.Log("Visual C++ 2012 Redistributable x86 not detected")
    return $null
}
catch {
    $Context.Log("Error during detection: $($_.Exception.Message)")
    return $null
}
