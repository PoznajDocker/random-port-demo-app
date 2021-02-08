FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
ENV ASPNETCORE_URLS="http://*:0"

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["RandomPort.csproj", "./"]
RUN dotnet restore "RandomPort.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "RandomPort.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RandomPort.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RandomPort.dll"]
