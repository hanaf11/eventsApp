#dobavljac ulaznica
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["eventsApp.DobavljacUlaznica/eventsApp.DobavljacUlaznica.csproj", "eventsApp.DobavljacUlaznica/"]
RUN dotnet restore "eventsApp.DobavljacUlaznica/eventsApp.DobavljacUlaznica.csproj"
COPY . .
RUN dotnet build "eventsApp.DobavljacUlaznica/eventsApp.DobavljacUlaznica.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "eventsApp.DobavljacUlaznica/eventsApp.DobavljacUlaznica.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "eventsApp.DobavljacUlaznica.dll"]