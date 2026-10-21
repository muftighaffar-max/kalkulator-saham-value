Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('D:\Downloads\Ringkasan Saham-20261013 (1).xlsx')
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
    $valCell    = $row.c | Where-Object { $_.r -match "^N" }
    $freqCell   = $row.c | Where-Object { $_.r -match "^O" }
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
        open         = if ($openCell -and $openCell.v) { [double]$openCell.v } else { $closeVal }
        high         = if ($highCell -and $highCell.v) { [double]$highCell.v } else { $closeVal }
        low          = if ($lowCell -and $lowCell.v) { [double]$lowCell.v } else { $closeVal }
        diff         = if ($diffCell -and $diffCell.v) { [double]$diffCell.v } else { 0 }
        volume       = if ($volCell -and $volCell.v) { [double]$volCell.v } else { 0 }
        value        = if ($valCell -and $valCell.v) { [double]$valCell.v } else { 0 }
        freq         = if ($freqCell -and $freqCell.v) { [double]$freqCell.v } else { 0 }
        listedShares = if ($sharesCell -and $sharesCell.v) { [double]$sharesCell.v } else { 0 }
    }
}

$reader.Dispose()
$stream.Dispose()
$zip.Dispose()

Write-Output "Parsed stocks: $($stocks.Count)"
$json = $stocks | ConvertTo-Json -Depth 3
[System.IO.File]::WriteAllText("D:\gemini\kalkulator-saham\idx_real_stocks.json", $json, [System.Text.Encoding]::UTF8)
Write-Output "Saved to D:\gemini\kalkulator-saham\idx_real_stocks.json successfully!"
