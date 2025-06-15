#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7294
ENV ASPNETCORE_URLS=http://+:7294

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "eventsApp/eventsApp.csproj" -c Release -o /app
COPY eventsApp.DB/seedDb.sql /app/eventsApp.DB/seedDb.sql

FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "eventsApp.dll"]