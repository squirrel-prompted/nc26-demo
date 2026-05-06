try {
    $Context.Log("Starting Visual C++ 2012 Redistributable x64 uninstallation")

    $UninstallArgs = "/uninstall /quiet /norestart"

    $UninstallRoots = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    $Match = $null
    foreach ($Root in $UninstallRoots) {
        if (-not (Test-Path -Path $Root)) { continue }

        $Match = Get-ChildItem -Path $Root -ErrorAction SilentlyContinue |
            Get-ItemProperty -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -match 'Visual C\+\+ 2012' -and $_.DisplayName -match 'x64' } |
            Select-Object -First 1

        if ($Match) { break }
    }

    if ($Match -and $Match.UninstallString) {
        $Context.Log("Uninstalling: $($Match.DisplayName) [$($Match.PSChildName)]")

        if ($Match.UninstallString -match '^"?(.+\.exe)"?\s*(.*)$') {
            $Executable = $matches[1]
            $Process = Start-Process -FilePath $Executable -ArgumentList $UninstallArgs -Wait -PassThru -NoNewWindow
            $ExitCode = $Process.ExitCode
            $Context.Log("Uninstallation completed with exit code: $ExitCode")
        }
    }
    else {
        $Context.Log("Visual C++ 2012 Redistributable x64 not found in registry")
    }

    $Context.Log("Visual C++ 2012 Redistributable x64 uninstallation completed successfully")
}
catch {
    $Context.Log("Uninstallation failed: $($_.Exception.Message)")
    throw
}
