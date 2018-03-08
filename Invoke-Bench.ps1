#!/bin/pwsh

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string] $Path,
  [int] $Connections = 10,
  [int] $Duration = 10,
  [int] $Timeout = 10
)

# See https://github.com/mcollina/autocannon for details.

$Config = .\_Config.ps1

$NetworkName = $Config.NetworkName
$AppName = $Config.AppName
$BenchName = $Config.BenchName
$BenchImage = $Config.BenchImage

function Invoke-Bench {
  .\_Log -Info:"Invoking bench '$BenchName' with image '$BenchImage'"
  docker run --name $BenchName --network $NetworkName -p 8089:8089 -it --rm $BenchImage `
    --latency -c $Connections -d $Duration -t $Timeout "http://$($AppName):5000$($Path)"
}

Invoke-Bench
