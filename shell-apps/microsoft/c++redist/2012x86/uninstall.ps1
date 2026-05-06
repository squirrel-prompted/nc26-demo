try {
    $Context.Log("Starting Visual C++ 2012 Redistributable x86 uninstallation")

    $RegistryPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{33d1fd90-4274-48a1-9bc1-97e33d9c2d6f}"

    $UninstallArgs = "/uninstall /quiet /norestart"

    if (Test-Path -Path $RegistryPath) {
        $Props = Get-ItemProperty -Path $RegistryPath -ErrorAction SilentlyContinue
        if ($Props.UninstallString) {
            $Context.Log("Uninstalling: $($Props.DisplayName)")

            if ($Props.UninstallString -match '^"?(.+\.exe)"?\s*(.*)$') {
                $Executable = $matches[1]
                $Process = Start-Process -FilePath $Executable -ArgumentList $UninstallArgs -Wait -PassThru -NoNewWindow
                $ExitCode = $Process.ExitCode
                $Context.Log("Uninstallation completed with exit code: $ExitCode")
            }
        }
    }
    else {
        $Context.Log("Visual C++ 2012 Redistributable x86 not found in registry")
    }

    $Context.Log("Visual C++ 2012 Redistributable x86 uninstallation completed successfully")
}
catch {
    $Context.Log("Uninstallation failed: $($_.Exception.Message)")
    throw
}
