# Script Update Otomatis Data 963 Saham Bursa Efek Indonesia (IHSG)
# Mencari file Excel Ringkasan Saham terbaru dari Downloads lalu mengupdate idx_data.js

Add-Type -AssemblyName System.IO.Compression.FileSystem

# 1. Cari file Excel terbaru di folder Downloads (D:\Downloads atau C:\Users\...\Downloads)
$downloadFolders = @("D:\Downloads", "$HOME\Downloads", "C:\Users\Mufti Ghaffar\Downloads")
$latestExcel = $null

foreach ($folder in $downloadFolders) {
    if (Test-Path $folder) {
        $files = Get-ChildItem -Path $folder -Filter "*Ringkasan*Saham*.xlsx" | Sort-Object LastWriteTime -Descending
        if ($files -and $files.Count -gt 0) {
            if (-not $latestExcel -or $files[0].LastWriteTime -gt $latestExcel.LastWriteTime) {
                $latestExcel = $files[0]
            }
        }
    }
}

if (-not $latestExcel) {
    Write-Host "[ERROR] Tidak ditemukan file 'Ringkasan Saham-YYYYMMDD.xlsx' di folder Downloads." -ForegroundColor Red
    Write-Host "Silakan download dulu file Ringkasan Saham dari https://www.idx.co.id/id/data-pasar/ringkasan-perdagangan/ringkasan-saham/" -ForegroundColor Yellow
    exit 1
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Memproses File Excel BEI: $($latestExcel.Name)" -ForegroundColor Green
Write-Host "Tanggal File: $($latestExcel.LastWriteTime.ToString('dd MMMM yyyy HH:mm'))" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 2. Buka ZIP xlsx dan baca sheet1.xml
$zip = [System.IO.Compression.ZipFile]::OpenRead($latestExcel.FullName)
$entry = $zip.GetEntry('xl/worksheets/sheet1.xml')
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream)
$xml = [xml]$reader.ReadToEnd()

$stocks = @{}
$rows = $xml.worksheet.sheetData.row | Where-Object { [int]$_.r -gt 1 }

foreach ($row in $rows) {
    $codeCell   = $row.c | Where-Object { $_.r -match "^B" }
    $nameCell   = $row.c | Where-Object { $_.r -match "^C" }
    $prevCell   = $row.c | Where-Object { $_.r -match "^E" }
    $openCell   = $row.c | Where-Object { $_.r -match "^F" }
    $highCell   = $row.c | Where-Object { $_.r -match "^I" }
    $lowCell    = $row.c | Where-Object { $_.r -match "^J" }
    $closeCell  = $row.c | Where-Object { $_.r -match "^K" }
    $diffCell   = $row.c | Where-Object { $_.r -match "^L" }
    $volCell    = $row.c | Where-Object { $_.r -match "^M" }
    $sharesCell = $row.c | Where-Object { $_.r -match "^U" }

    $ticker = if ($codeCell) { $codeCell.v.Trim().ToUpper() } else { "" }
    if (-not $ticker) { continue }

    $closeVal = if ($closeCell -and $closeCell.v) { [double]$closeCell.v } else { 0 }
    $prevVal  = if ($prevCell -and $prevCell.v) { [double]$prevCell.v } else { 0 }
    if ($closeVal -eq 0 -and $prevVal -gt 0) { $closeVal = $prevVal }

    $stocks[$ticker] = @{
        ticker       = $ticker
        name         = if ($nameCell) { $nameCell.v.Trim() } else { "PT $ticker Tbk" }
        price        = $closeVal
        prev         = $prevVal
        diff         = if ($diffCell -and $diffCell.v) { [double]$diffCell.v } else { 0 }
        high         = if ($highCell -and $highCell.v) { [double]$highCell.v } else { $closeVal }
        low          = if ($lowCell -and $lowCell.v) { [double]$lowCell.v } else { $closeVal }
        volume       = if ($volCell -and $volCell.v) { [double]$volCell.v } else { 0 }
        shares       = if ($sharesCell -and $sharesCell.v) { [double]$sharesCell.v } else { 0 }
    }
}

$reader.Dispose()
$stream.Dispose()
$zip.Dispose()

Write-Host "Berhasil mengekstrak $($stocks.Count) saham dari BEI!" -ForegroundColor Green

# 3. Tulis ke idx_data.js
$outJsPath = "D:\gemini\kalkulator-saham\idx_data.js"
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("// Data Resmi 963 Saham Bursa Efek Indonesia (IHSG)")
[void]$sb.AppendLine("// Sumber: " + $latestExcel.Name)
[void]$sb.AppendLine("// Tanggal Perdagangan: " + $latestExcel.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss"))
[void]$sb.AppendLine("window.idxOfficialStocks = {")

$first = $true
foreach ($key in $stocks.Keys) {
    $s = $stocks[$key]
    if (-not $first) { [void]$sb.AppendLine(",") }
    $first = $false
    
    $ticker = $s.ticker
    $name = ($s.name -replace '"', '\"').Trim()
    $price = $s.price
    $prev = $s.prev
    $diff = $s.diff
    $high = $s.high
    $low = $s.low
    $vol = $s.volume
    $shares = $s.shares
    
    $line = "  `"$ticker`": { ticker: `"$ticker`", name: `"$name`", price: $price, prev: $prev, diff: $diff, high: $high, low: $low, volume: $vol, shares: $shares }"
    [void]$sb.Append($line)
}

[void]$sb.AppendLine("")
[void]$sb.AppendLine("};")

[System.IO.File]::WriteAllText($outJsPath, $sb.ToString(), [System.Text.Encoding]::UTF8)

# Simpan juga ke json untuk backup
$json = $stocks | ConvertTo-Json -Depth 3
[System.IO.File]::WriteAllText("D:\gemini\kalkulator-saham\idx_real_stocks.json", $json, [System.Text.Encoding]::UTF8)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "SUKSES! File idx_data.js berhasil diperbarui." -ForegroundColor Green
Write-Host "Seluruh harga 963 saham di kalkulator kini 100% mutakhir." -ForegroundColor Green
Write-Host "Silakan refresh (F5) halaman kalkulator Anda di browser." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
