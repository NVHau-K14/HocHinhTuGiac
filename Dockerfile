# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy file .csproj theo đúng cấu trúc thư mục và restore
COPY ["src/QuadWeb/QuadWeb.csproj", "src/QuadWeb/"]
RUN dotnet restore "src/QuadWeb/QuadWeb.csproj"

# Copy toàn bộ source code vào và build
COPY . .
WORKDIR "/src/src/QuadWeb"
RUN dotnet publish "QuadWeb.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Cấu hình cổng cho ASP.NET Core
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "QuadWeb.dll"]