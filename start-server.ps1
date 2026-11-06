# Zero-dependency local web server & REST API using Windows PowerShell HttpListener
param([int]$Port = 3000)

$Root = $PSScriptRoot
$DbFile = Join-Path $Root "backend-node\rides.json"

if (-not (Test-Path $DbFile)) {
    $DbFile = Join-Path $Root "backend-python\rides.json"
}

$Listener = New-Object System.Net.HttpListener
$Prefix = "http://localhost:$Port/"
$Listener.Prefixes.Add($Prefix)

try {
    $Listener.Start()
} catch {
    Write-Host "Failed to start listener on port $Port : $_" -ForegroundColor Red
    exit 1
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " 🚀 RideSplit Local Server running at: $Prefix" -ForegroundColor Green
Write-Host " 📂 Serving files from: $Root" -ForegroundColor DarkGray
Write-Host " 🛑 Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# Open browser automatically
Start-Process $Prefix

function Get-ContentType($ext) {
    switch ($ext.ToLower()) {
        ".html" { return "text/html; charset=utf-8" }
        ".htm"  { return "text/html; charset=utf-8" }
        ".css"  { return "text/css; charset=utf-8" }
        ".js"   { return "application/javascript; charset=utf-8" }
        ".json" { return "application/json; charset=utf-8" }
        ".png"  { return "image/png" }
        ".jpg"  { return "image/jpeg" }
        ".svg"  { return "image/svg+xml" }
        ".ico"  { return "image/x-icon" }
        default { return "application/octet-stream" }
    }
}

while ($Listener.IsListening) {
    try {
        $Context = $Listener.GetContext()
        $Request = $Context.Request
        $Response = $Context.Response

        $UrlPath = $Request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($UrlPath)) {
            $UrlPath = "index.html"
        }

        # Add CORS headers
        $Response.Headers.Add("Access-Control-Allow-Origin", "*")
        $Response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        $Response.Headers.Add("Access-Control-Allow-Headers", "Content-Type")

        if ($Request.HttpMethod -eq "OPTIONS") {
            $Response.StatusCode = 204
            $Response.Close()
            continue
        }

        # API Endpoints
        if ($UrlPath -eq "api/rides" -and $Request.HttpMethod -eq "GET") {
            $Response.ContentType = "application/json; charset=utf-8"
            if (Test-Path $DbFile) {
                $bytes = [System.IO.File]::ReadAllBytes($DbFile)
            } else {
                $bytes = [System.Text.Encoding]::UTF8.GetBytes("[]")
            }
            $Response.OutputStream.Write($bytes, 0, $bytes.Length)
            $Response.Close()
            continue
        }

        if ($UrlPath -eq "api/rides" -and $Request.HttpMethod -eq "POST") {
            $reader = New-Object System.IO.StreamReader($Request.InputStream, $Request.ContentEncoding)
            $body = $reader.ReadToEnd()
            $newRide = $body | ConvertFrom-Json

            $rides = @()
            if (Test-Path $DbFile) {
                $content = Get-Content $DbFile -Raw
                if ($content) { $rides = $content | ConvertFrom-Json }
            }

            $rides = @($newRide) + $rides
            $rides | ConvertTo-Json -Depth 5 | Set-Content $DbFile -Encoding UTF8

            $Response.StatusCode = 201
            $Response.ContentType = "application/json; charset=utf-8"
            $respBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
            $Response.OutputStream.Write($respBytes, 0, $respBytes.Length)
            $Response.Close()
            continue
        }

        # Static File Serving
        $FilePath = Join-Path $Root $UrlPath
        if (Test-Path $FilePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($FilePath)
            $Response.ContentType = Get-ContentType $ext
            $bytes = [System.IO.File]::ReadAllBytes($FilePath)
            $Response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $Response.StatusCode = 404
            $err = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $Response.OutputStream.Write($err, 0, $err.Length)
        }
        $Response.Close()
    } catch {
        # continue loop
    }
}
