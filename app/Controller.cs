using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace App
{
  public class Controller : Microsoft.AspNetCore.Mvc.Controller
  {
    private readonly ILogger Logger;

    public Controller(ILoggerFactory loggerFactory)
    {
      Logger = loggerFactory.CreateLogger("App.Controller");
    }

    [HttpGet]
    [Route("/sync")]
    public IActionResult GetSync()
    {
      var stopwatch = Stopwatch.StartNew();
      try
      {
        RunSyncQuery();
        Logger.LogInformation(200, $"/sync 200 {stopwatch.ElapsedMilliseconds}ms");
        return StatusCode(200);
      }
      catch (Exception ex)
      {
        Logger.LogError(500, ex, $"/sync 500 {stopwatch.ElapsedMilliseconds}ms");
        return StatusCode(500, ex.ToString());
      }
    }

    [HttpGet]
    [Route("/async")]
    public async Task<IActionResult> GetAsync()
    {
      var stopwatch = Stopwatch.StartNew();
      try
      {
        await RunAsyncQuery();
        Logger.LogInformation(200, $"/async 200 {stopwatch.ElapsedMilliseconds}ms");
        return StatusCode(200);
      }
      catch (Exception ex)
      {
        Logger.LogError(500, ex, $"/async 500 {stopwatch.ElapsedMilliseconds}ms");
        return StatusCode(500, ex.ToString());
      }
    }

    private void RunSyncQuery()
    {
      using (var conn = new SqlConnection(GetConnectionString()))
      {
        using (var cmd = new SqlCommand("SELECT * FROM Table1;", conn))
        {
          conn.Open();
          var reader = cmd.ExecuteReader();
          while (reader.Read())
          {
            reader.GetGuid(0);
          }
        }
      }
    }

    private async Task RunAsyncQuery()
    {
      using (var conn = new SqlConnection(GetConnectionString()))
      {
        using (var cmd = new SqlCommand("SELECT * FROM Table1;", conn))
        {
          conn.Open();
          var reader = await cmd.ExecuteReaderAsync();
          while (await reader.ReadAsync())
          {
            reader.GetGuid(0);
          }
        }
      }
    }

    private string GetConnectionString()
    {
      var server = Environment.GetEnvironmentVariable("DB_SERVER");
      var userId = Environment.GetEnvironmentVariable("DB_USER_ID");
      var password = Environment.GetEnvironmentVariable("DB_PASSWORD");
      return $"Server={server};User Id={userId};Password={password};Trusted_Connection=False;";
    }
  }
}
