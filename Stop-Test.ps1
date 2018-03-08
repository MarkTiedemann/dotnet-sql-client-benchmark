#!/bin/pwsh

$Config = .\_Config.ps1

$NetworkName = $Config.NetworkName
$DbName = $Config.DbName
$AppName = $Config.AppName

function Stop-Test {
  .\_Log -Info:"Stopping db '$DbName'"
  docker stop $DbName

  .\_Log -Info:"Stopping app '$AppName'"
  docker stop $AppName

  .\_Log -Info:"Removing network '$NetworkName'"
  docker network rm $NetworkName
}

Stop-Test
