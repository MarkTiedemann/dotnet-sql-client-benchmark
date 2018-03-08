using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

namespace App
{
  public class Program
  {
    public static void Main() => WebHost.CreateDefaultBuilder()
      .Configure(app => app.UseMvc())
      .ConfigureServices(services => services.AddMvc())
      .Build()
      .Run();
  }
}
