FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["eventsApp.Subscriber/eventsApp.Subscriber.csproj", "eventsApp.Subscriber/"]
COPY ["eventsApp.Model/eventsApp.Model.csproj", "eventsApp.Model/"]
COPY ["eventsApp.Services/eventsApp.Services.csproj", "eventsApp.Services/"]
RUN dotnet restore "eventsApp.Subscriber/eventsApp.Subscriber.csproj"
COPY . .
RUN dotnet build "eventsApp.Subscriber/eventsApp.Subscriber.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "eventsApp.Subscriber/eventsApp.Subscriber.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "eventsApp.Subscriber.dll"]