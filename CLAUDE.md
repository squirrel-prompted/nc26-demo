## Structure

Each app lives in `{Vendor}/{App}/{Version}` with four files: `detect.ps1`, `install.ps1`, `uninstall.ps1`, `README.md`.

### detect.ps1

- Return version string if installed, `$null` if not.
- Validate against `$Context.TargetVersion` in format x.x.x.x

### install.ps1 / uninstall.ps1

- No detection logic.
- Return void on success.

## Conventions

- Scripts run as SYSTEM.
- Log with `$Context.Log()`, not `Write-Output`.
- Use identical variable names for shared concepts across all three scripts.
- Store exit codes before checking: `$ExitCode = $Process.ExitCode`; error format: `"Operation failed with exit code: $ExitCode"`
- In catch blocks, use `throw` (not `throw $_`).
- No file existence checks after operations that throw on failure.
- Update README.md when script behavior changes.
