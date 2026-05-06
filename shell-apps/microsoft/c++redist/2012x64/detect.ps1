try {
    $Context.Log("Starting Visual C++ 2012 Redistributable x64 detection")

    if ($null -ne $Context.TargetVersion) {
        $Context.Log("Target version: $($Context.TargetVersion)")
    }

    $UninstallRoots = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    foreach ($Root in $UninstallRoots) {
        if (-not (Test-Path -Path $Root)) { continue }

        $Match = Get-ChildItem -Path $Root -ErrorAction SilentlyContinue |
            Get-ItemProperty -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -match 'Visual C\+\+ 2012' -and $_.DisplayName -match 'x64' } |
            Select-Object -First 1

        if ($Match -and $Match.DisplayVersion) {
            $Context.Log("Found: $($Match.DisplayName) - Version: $($Match.DisplayVersion) [$($Match.PSChildName)]")
            return $Match.DisplayVersion
        }
    }

    $Context.Log("Visual C++ 2012 Redistributable x64 not detected")
    return $null
}
catch {
    $Context.Log("Error during detection: $($_.Exception.Message)")
    return $null
}
