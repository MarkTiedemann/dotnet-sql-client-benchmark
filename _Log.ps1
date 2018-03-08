#!/bin/pwsh

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string] $Info
)

$Date = Get-Date -Format:'HH:mm:ss'
Write-Host -Object:"[INFO] $Info ($Date)" -ForegroundColor:Cyan
