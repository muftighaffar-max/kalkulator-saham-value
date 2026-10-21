Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('D:\Downloads\Ringkasan Saham-20261013 (1).xlsx')
$entry = $zip.GetEntry('xl/worksheets/sheet1.xml')
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream)
$xml = [xml]$reader.ReadToEnd()

$testCodes = @("PANI", "AMRT", "BBCA", "ARTO", "BUAH", "GOTO", "TLKM", "ASII")
$rows = $xml.worksheet.sheetData.row | Where-Object { [int]$_.r -gt 1 }

foreach ($row in $rows) {
    $codeCell = $row.c | Where-Object { $_.r -match "^B" }
    $code = $codeCell.v
    if ($testCodes -contains $code) {
        $nameCell = $row.c | Where-Object { $_.r -match "^C" }
        $prevCell = $row.c | Where-Object { $_.r -match "^E" }
        $openCell = $row.c | Where-Object { $_.r -match "^F" }
        $highCell = $row.c | Where-Object { $_.r -match "^I" }
        $lowCell  = $row.c | Where-Object { $_.r -match "^J" }
        $closeCell = $row.c | Where-Object { $_.r -match "^K" }
        $sharesCell = $row.c | Where-Object { $_.r -match "^U" }
        $fBuyCell = $row.c | Where-Object { $_.r -match "^Y" }
        $fSellCell = $row.c | Where-Object { $_.r -match "^X" }
        
        Write-Output "Ticker: $code | Name: $($nameCell.v) | Close: $($closeCell.v) | Prev: $($prevCell.v) | High: $($highCell.v) | Low: $($lowCell.v) | Shares: $($sharesCell.v)"
    }
}

$reader.Dispose()
$stream.Dispose()
$zip.Dispose()
