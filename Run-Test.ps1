#!/bin/pwsh

$NetworkName = 'net1'

$DbName = 'db1'
$DbImage = 'microsoft/mssql-server-linux:2017-CU3'
$DbClient = '/opt/mssql-tools/bin/sqlcmd'

$DbUserId = 'sa'
$DbPassword = 'dbPassword1!'

$AppName = 'app1'
$AppImage = 'app:latest'
$AppPath = 'app'

$BenchName = 'bench1'
$BenchImage = 'bench:latest'
$BenchPath = 'bench'

function Write-Info ($Info) {
  $Date = Get-Date -Format:'HH:mm:ss'
  Write-Host -Object:"[INFO] $Info ($Date)" -ForegroundColor:Cyan
}

function Stop-Test {
  Write-Info "Stopping db '$DbName'"
  docker stop $DbName

  Write-Info "Stopping app '$AppName'"
  docker stop $AppName

  Write-Info "Stopping bench '$BenchName'"
  docker stop $BenchName

  Write-Info "Removing network '$NetworkName'"
  docker network rm $NetworkName
}

function Start-Test {
  Write-Info "Building app '$AppImage'"
  docker build --tag $AppImage --rm --file $AppPath/Dockerfile $AppPath

  Write-Info "Building bench '$BenchImage'"
  docker build --tag $BenchImage --rm --file $BenchPath/Dockerfile $BenchPath

  Write-Info "Creating network '$Networkname'"
  docker network create $NetworkName

  Write-Info "Starting db '$DbName' with image '$DbImage'"
  docker run --name $DbName --network $NetworkName -p 1433:1433 -d --rm `
    -e ACCEPT_EULA=Y -e SA_PASSWORD=$DbPassword $DbImage

  do {
    Start-Sleep -Seconds:1
    $ReadinessQuery = 'SELECT @@SERVERNAME'
    $Ready = docker exec $DbName $DbClient -S localhost -U $DbUserId -P $DbPassword -Q $ReadinessQuery
  } while ($Ready -eq $null)

  $CreateTableQuery = 'CREATE TABLE Table1 (Id uniqueidentifier NOT NULL, CONSTRAINT Table1PK PRIMARY KEY (Id))'
  docker exec $DbName $DbClient -S localhost -U $DbUserId -P $DbPassword -Q $CreateTableQuery

  Write-Info "Starting app '$AppName' with image '$AppImage'"
  docker run --name $AppName --network $NetworkName -p 5000:5000 -d --rm `
    -e DB_SERVER=$DbName -e DB_USER_ID=$DbUserId -e DB_PASSWORD=$DbPassword $AppImage

  Write-Info "Starting bench '$BenchName' with image '$BenchImage'"
  docker run --name $BenchName --network $NetworkName -p 8089:8089 -d --rm $BenchImage `
    --host http://$($AppName):5000
}

# Stop previous test
Stop-Test

# Start new test
Start-Test
