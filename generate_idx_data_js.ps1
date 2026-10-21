$jsonPath = "D:\gemini\kalkulator-saham\idx_real_stocks.json"
$outJsPath = "D:\gemini\kalkulator-saham\idx_data.js"

$raw = Get-Content $jsonPath -Raw | ConvertFrom-Json
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("// Data Resmi 963 Saham Bursa Efek Indonesia (IHSG)")
[void]$sb.AppendLine("// Sumber: Ringkasan Saham BEI (idx.co.id)")
[void]$sb.AppendLine("// Diperbarui otomatis: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
[void]$sb.AppendLine("window.idxOfficialStocks = {")

$first = $true
foreach ($prop in $raw.PSObject.Properties) {
    $s = $prop.Value
    if (-not $first) { [void]$sb.AppendLine(",") }
    $first = $false
    
    $ticker = $s.ticker
    $name = ($s.name -replace '"', '\"').Trim()
    $price = [double]$s.price
    $prev = [double]$s.prev
    $diff = [double]$s.diff
    $high = [double]$s.high
    $low = [double]$s.low
    $vol = [double]$s.volume
    $shares = [double]$s.listedShares
    
    $line = "  `"$ticker`": { ticker: `"$ticker`", name: `"$name`", price: $price, prev: $prev, diff: $diff, high: $high, low: $low, volume: $vol, shares: $shares }"
    [void]$sb.Append($line)
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("};")

[System.IO.File]::WriteAllText($outJsPath, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Generated idx_data.js successfully! File size: $((Get-Item $outJsPath).Length) bytes."
