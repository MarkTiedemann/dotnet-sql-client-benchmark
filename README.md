# dotnet-sql-client-benchmark

**.NET Core SQL Client benchmark.**

## Usage

1.  **Build the test images:**

```powershell
pwsh New-Test.ps1
```

2.  **Start the test containers:**

```powershell
pwsh Start-Test.ps1
```

3.  **Run your own benchmarks:**

```powershell
pwsh Invoke-Bench.ps1 -Path:/sync -Connections:10 -Duration:10 -Timeout:10
pwsh Invoke-Bench.ps1 -Path:/async -Connections:10 -Duration:10 -Timeout:10
```

4.  **Stop the test containers:**

```powershell
pwsh Stop-Test.ps1
```

## License

[WTFPL](http://www.wtfpl.net/) – Do What the F\*ck You Want to Public License.

Made with :heart: by [@MarkTiedemann](https://twitter.com/MarkTiedemannDE).
