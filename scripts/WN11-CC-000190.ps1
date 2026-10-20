<#
.SYNOPSIS
    Turns off AutoPlay for all drive types to satisfy WN11-CC-000190.

.NOTES
    Author          : Zach Simolke
    GitHub          : [Your GitHub URL]
    Date Created    : 2026-10-19
    Last Modified   : 2026-10-19
    Version         : 1.0
    CVEs            : None listed in the STIG
    Plugin IDs      : None listed in the STIG
    STIG-ID         : WN11-CC-000190
    Vuln-ID         : V-253388
    STIG Version    : Windows 11 V2R11 (30 Sep 2026)
    Severity        : CAT I (high)

.TESTED ON
    Date(s) Tested  : 10-19-2026
    Tested By       : Zach Simolke
    Systems Tested  : Windows 11 Pro
    PowerShell Ver. :

.USAGE
    Run from an elevated PowerShell session.
    Example syntax:
    PS C:\> .\WN11-CC-000190.ps1               # remediate
    PS C:\> .\WN11-CC-000190.ps1 -AuditOnly    # report only, change nothing
    PS C:\> .\WN11-CC-000190.ps1 -WhatIf       # preview the change
    PS C:\> .\WN11-CC-000190.ps1 -Rollback     # restore the value saved before remediation
    Note: 255 is 0xFF, the value the STIG requires (AutoPlay off for all drives).

.VERIFICATION CHECK
    Expected registry path:
    HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer

    Expected registry value:
    NoDriveTypeAutoRun = 255 (REG_DWORD)
#>

#Requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$AuditOnly,
    [switch]$Rollback
)

$StigId     = 'WN11-CC-000190'
$RegPath    = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer'
$ValueName  = 'NoDriveTypeAutoRun'
$Desired    = 255
$BackupDir  = Join-Path $env:ProgramData 'STIG-Backups'
$BackupFile = Join-Path $BackupDir "$StigId.json"

function Get-State {
    $p = Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction SilentlyContinue
    if ($null -ne $p) { $p.$ValueName } else { $null }
}

function Show-State ($Label) {
    $v = Get-State
    $shown  = if ($null -eq $v) { '<not set>' } else { $v }
    $result = if ($v -eq $Desired) { 'COMPLIANT' } else { 'FINDING' }
    Write-Host ("{0,-8}: {1} = {2}  [{3}]" -f $Label, $ValueName, $shown, $result)
}

Write-Host "==== $StigId ===="
Show-State 'Current'

if ($Rollback) {
    if (-not (Test-Path $BackupFile)) { Write-Warning "No backup found at $BackupFile"; return }
    $prior = Get-Content -Path $BackupFile -Raw | ConvertFrom-Json
    if ($PSCmdlet.ShouldProcess("$RegPath\$ValueName", 'Restore prior state')) {
        if ($prior.Existed) {
            New-ItemProperty -Path $RegPath -Name $ValueName -PropertyType DWord -Value $prior.Value -Force | Out-Null
        }
        else {
            Remove-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction SilentlyContinue
        }
        Show-State 'Restored'
    }
    return
}

if ($AuditOnly) { return }

if ((Get-State) -eq $Desired) {
    Write-Host 'Already compliant. No change made.'
    return
}

if ($PSCmdlet.ShouldProcess("$RegPath\$ValueName", "Set to $Desired")) {
    # Save the original state once so a rollback is always possible
    if (-not (Test-Path $BackupFile)) {
        if (-not (Test-Path $BackupDir)) { New-Item -Path $BackupDir -ItemType Directory -Force | Out-Null }
        $original = Get-State
        [pscustomobject]@{ Existed = ($null -ne $original); Value = $original } |
            ConvertTo-Json | Set-Content -Path $BackupFile
    }
    if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
    New-ItemProperty -Path $RegPath -Name $ValueName -PropertyType DWord -Value $Desired -Force | Out-Null
    Show-State 'After'
}
