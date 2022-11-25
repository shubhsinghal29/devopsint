FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

WORKDIR /app

COPY ./*.csproj /app/

RUN dotnet restore

FROM build as publish

WORKDIR /app

COPY . .

RUN dotnet publish ./*.csproj -c Release -o ./app/bin/Release/net

FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS runtime

WORKDIR /app

COPY --from=publish /app/app/bin/Debug/net6.0 ./app/bin/Release/net

ENTRYPOINT ["dotnet", "./app/bin/Release/net/*.dll"]
