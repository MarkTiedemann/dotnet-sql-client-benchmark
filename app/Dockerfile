FROM microsoft/dotnet:2.0.0-sdk
WORKDIR /app

COPY app.csproj .
RUN dotnet restore

COPY ./ .
RUN dotnet publish --configuration Release --no-restore

ENV ASPNETCORE_URLS http://*:5000
ENV ASPNETCORE_ENVIRONMENT Production

ENTRYPOINT ["dotnet", "bin/Release/netcoreapp2.0/app.dll"]