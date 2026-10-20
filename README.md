# DISA STIG Remediation Project
 
## STIG Remediation Index Table
 
Remediation scripts for the DISA Microsoft Windows 11 STIG, **V2R11** (30 Sep 2026).
 
This table links each STIG ID to its matching remediation script and the screenshot folder used to capture pass/fail/remediation validation evidence.
 
| STIG ID | Remediation Powershell Script | Pass/Fail/Remediation | Description |
| --- | --- | --- | --- |
| WN11-00-000150 | [Powershell Script](scripts/WN11-00-000150.ps1) | Pending validation | Enables SEHOP to block structured exception handler overwrite exploits. |
| WN11-CC-000165 | [Powershell Script](scripts/WN11-CC-000165.ps1) | Pending validation | Blocks unauthenticated RPC clients from connecting to the RPC server. |
| WN11-CC-000190 | [Powershell Script](scripts/WN11-CC-000190.ps1) | Pending validation | Turns off AutoPlay on all drive types. |
| WN11-CC-000270 | [Powershell Script](scripts/WN11-CC-000270.ps1) | Pending validation | Prevents passwords from being saved in the Remote Desktop client. |
| WN11-CC-000335 | [Powershell Script](scripts/WN11-CC-000335.ps1) | Pending validation | Prevents the WinRM client from allowing unencrypted traffic. |
| WN11-SO-000030 | [Powershell Script](scripts/WN11-SO-000030.ps1) | Pending validation | Forces advanced audit subcategory settings to override legacy category settings. |
| WN11-SO-000100 | [Powershell Script](scripts/WN11-SO-000100.ps1) | Pending validation | Requires SMB client packet signing. |
| WN11-SO-000120 | [Powershell Script](scripts/WN11-SO-000120.ps1) | Pending validation | Requires SMB server packet signing. |
| WN11-SO-000150 | [Powershell Script](scripts/WN11-SO-000150.ps1) | Pending validation | Blocks anonymous enumeration of SAM accounts and shares. |
| WN11-SO-000205 | [Powershell Script](scripts/WN11-SO-000205.ps1) | Pending validation | Requires NTLMv2 only and refuses LM and NTLM authentication. |
| WN11-SO-000145 | [Powershell Script](scripts/WN11-SO-000145.ps1) | Pending validation | Blocks anonymous enumeration of SAM accounts. |
| WN11-SO-000165 | [Powershell Script](scripts/WN11-SO-000165.ps1) | Pending validation | Restricts anonymous access to named pipes and shares. |
| WN11-SO-000270 | [Powershell Script](scripts/WN11-SO-000270.ps1) | Pending validation | Keeps UAC Admin Approval Mode enabled for all administrators. |
 
## Script conventions
 
Every script runs from an elevated PowerShell session and supports:
 
- `-AuditOnly` reports the current state and changes nothing
- `-WhatIf` previews the change
- `-Rollback` restores the value saved before remediation (backups are written to `%ProgramData%\STIG-Backups`)
