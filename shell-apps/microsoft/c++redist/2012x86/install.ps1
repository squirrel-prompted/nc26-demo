try {
    $Context.Log("Starting Visual C++ 2012 Redistributable x86 installation")
    $Context.Log("Target version: $($Context.TargetVersion)")
    $Context.Log("Detected version: $($Context.DetectedVersion)")

    $SetupFolder = $env:TEMP
    $Context.Log("Using setup folder: $SetupFolder")

    $InstallArgs = "/install /quiet /norestart"
    $SuccessExitCodes = @(0, 3010)

    $InstallerPath = Join-Path $SetupFolder "vcredist_x86_2012.exe"

    if (-not (Test-Path -Path $InstallerPath)) {
        $Context.Log("Downloading Visual C++ 2012 Redistributable x86 installer")
        $VCRedistURI = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"
        Invoke-WebRequest -Uri $VCRedistURI -OutFile $InstallerPath -UseBasicParsing

        if (-not (Test-Path -Path $InstallerPath)) {
            throw "Visual C++ 2012 Redistributable x86 installer download completed but file not found at $InstallerPath"
        }
        $Context.Log("Visual C++ 2012 Redistributable x86 installer downloaded successfully")
    }
    else {
        $Context.Log("Visual C++ 2012 Redistributable x86 installer already exists at $InstallerPath")
    }

    $FileSize = (Get-Item -Path $InstallerPath).Length
    $Context.Log("Installer ready - Size: $([math]::Round($FileSize / 1MB, 2)) MB")

    $Context.Log("Installing Visual C++ 2012 Redistributable x86")
    $Process = Start-Process -FilePath $InstallerPath -ArgumentList $InstallArgs -Wait -PassThru

    $ExitCode = $Process.ExitCode
    $Context.Log("Installation process completed with exit code: $ExitCode")

    if ($SuccessExitCodes -notcontains $ExitCode) {
        throw "Visual C++ 2012 Redistributable x86 installation failed with exit code: $ExitCode"
    }

    $Context.Log("Visual C++ 2012 Redistributable x86 installation completed successfully")
}
catch {
    $Context.Log("Installation failed: $($_.Exception.Message)")
    throw
}
