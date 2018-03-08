#!/bin/pwsh

New-Object PsObject -Property:@{
  NetworkName = 'net1'

  DbName      = 'db1'
  DbImage     = 'microsoft/mssql-server-linux:2017-CU3'
  DbClient    = '/opt/mssql-tools/bin/sqlcmd'

  DbUserId    = 'sa'
  DbPassword  = 'dbPassword1!'

  AppName     = 'app1'
  AppImage    = 'app:latest'
  AppPath     = 'app'

  BenchName   = 'bench1'
  BenchImage  = 'bench:latest'
  BenchPath   = 'bench'
}
