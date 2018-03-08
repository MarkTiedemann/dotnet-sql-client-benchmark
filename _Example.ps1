#!/bin/pwsh

$Options = @{ Timeout = 5; Duration = 30 }
$Connections = 20, 40, 60, 80, 100

$Connections | ForEach-Object {
  # Benchmark /sync
  .\Invoke-Bench.ps1 -Path:/sync -Connections:$_ @Options
  Start-Sleep -Seconds:5
  # Benchmark /async
  .\Invoke-Bench.ps1 -Path:/async -Connections:$_ @Options
  Start-Sleep -Seconds:5
}
