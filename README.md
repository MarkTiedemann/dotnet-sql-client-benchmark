# dotnet-sql-client-benchmark

**.NET Core SQL Client benchmark.**

## Requirements

* [`docker`](https://www.docker.com/), v17
* [`pwsh`](https://github.com/powershell/powershell), v6

## Usage

1.  **Build the test images:**

```powershell
.\New-Test.ps1
```

2.  **Start the test containers:**

```powershell
.\Start-Test.ps1
```

3.  **Run your own benchmarks, for example:**

```powershell
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
```

4.  **Stop the test containers:**

```powershell
.\Stop-Test.ps1
```

## License

[WTFPL](http://www.wtfpl.net/) – Do What the F\*ck You Want to Public License.

Made with :heart: by [@MarkTiedemann](https://twitter.com/MarkTiedemannDE).
