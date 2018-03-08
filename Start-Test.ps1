#!/bin/pwsh

$Config = .\_Config.ps1

$NetworkName = $Config.Networkname
$DbName = $Config.DbName
$DbImage = $Config.DbImage
$DbClient = $Config.DbClient
$DbUserId = $Config.DbUserId
$DbPassword = $Config.DbPassword
$AppName = $Config.AppName
$AppImage = $Config.AppImage
$BenchName = $Config.BenchName
$BenchImage = $Config.BenchImage

function Start-Test {
  .\_Log -Info:"Creating network '$Networkname'"
  docker network create $NetworkName

  .\_Log -Info:"Starting db '$DbName' with image '$DbImage'"
  docker run --name $DbName --network $NetworkName -p 1433:1433 -d --rm `
    -e ACCEPT_EULA=Y -e SA_PASSWORD=$DbPassword $DbImage

  do {
    Start-Sleep -Seconds:1
    $ReadinessQuery = 'SELECT @@SERVERNAME'
    $Ready = docker exec $DbName $DbClient -S localhost -U $DbUserId -P $DbPassword -Q $ReadinessQuery
  } while ($Ready -eq $null)

  $CreateTableQuery = 'CREATE TABLE Table1 (Id uniqueidentifier NOT NULL, CONSTRAINT Table1PK PRIMARY KEY (Id))'
  docker exec $DbName $DbClient -S localhost -U $DbUserId -P $DbPassword -Q $CreateTableQuery

  .\_Log -Info:"Starting app '$AppName' with image '$AppImage'"
  docker run --name $AppName --network $NetworkName -p 5000:5000 -d --rm `
    -e DB_SERVER=$DbName -e DB_USER_ID=$DbUserId -e DB_PASSWORD=$DbPassword $AppImage

  .\_Log -Info:"Executing bench '$BenchName' with image '$BenchImage'"
  docker run --name $BenchName --network $NetworkName -p 8089:8089 -d --rm $BenchImage `
    --host http://$($AppName):5000
}

Start-Test
