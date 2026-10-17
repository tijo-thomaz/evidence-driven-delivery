# Manual install of AI-DLC into your user-level Claude Code config (Windows PowerShell).
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1 [-Project]   (-Project installs into .\.claude instead)
param([switch]$Project)
$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$dest = if ($Project) { Join-Path (Get-Location) '.claude' } else { Join-Path $env:USERPROFILE '.claude' }

New-Item -ItemType Directory -Force (Join-Path $dest 'skills'), (Join-Path $dest 'agents') | Out-Null
Copy-Item (Join-Path $src 'skills\aidlc') (Join-Path $dest 'skills') -Recurse -Force
Copy-Item (Join-Path $src 'agents\aidlc-*.md') (Join-Path $dest 'agents') -Force

$n = (Get-ChildItem (Join-Path $src 'agents\aidlc-*.md')).Count
Write-Output "Installed the aidlc skill and $n agents into $dest"
Write-Output "Restart Claude Code, then type /aidlc in any project."
