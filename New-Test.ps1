#!/bin/pwsh

$Config = .\_Config.ps1

$AppImage = $Config.AppImage
$AppPath = $Config.AppPath
$BenchImage = $Config.BenchImage
$BenchPath = $Config.BenchPath

function New-Test {
  .\_Log -Info:"Building app '$AppImage'"
  docker build --tag $AppImage --rm --file $AppPath/Dockerfile $AppPath

  .\_Log -Info:"Building bench '$BenchImage'"
  docker build --tag $BenchImage --rm --file $BenchPath/Dockerfile $BenchPath
}

New-Test
