FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

WORKDIR /app

COPY ./*.csproj /app/

RUN ls -lrt

RUN dotnet restore

FROM build as publish

WORKDIR /app

COPY . .
RUN ls -lrt

RUN dotnet publish ./*.csproj -c Release -o ./app/bin/Release/net

FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS runtime

WORKDIR /app

COPY --from=publish /app/app/bin/Release/net ./app/bin/Release/net
RUN ls -lrt

ENTRYPOINT ["dotnet", "./app/bin/Release/net/*.dll"]
