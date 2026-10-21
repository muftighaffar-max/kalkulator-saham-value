Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('D:\Downloads\Ringkasan Saham-20261013 (1).xlsx')
$entry = $zip.GetEntry('xl/worksheets/sheet1.xml')
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream)
$xml = [xml]$reader.ReadToEnd()

$rows = $xml.worksheet.sheetData.row | Where-Object { [int]$_.r -gt 1 }
Write-Output "Total data rows: $($rows.Count)"

$zeroClose = 0
$hasClose = 0
foreach ($row in $rows) {
    $codeCell = $row.c | Where-Object { $_.r -match "^B" }
    $closeCell = $row.c | Where-Object { $_.r -match "^K" }
    $prevCell = $row.c | Where-Object { $_.r -match "^E" }
    $closeVal = if ($closeCell) { [double]$closeCell.v } else { 0 }
    if ($closeVal -gt 0) {
        $hasClose++
    } else {
        $zeroClose++
    }
}
Write-Output "Stocks with Close > 0: $hasClose"
Write-Output "Stocks with Close == 0 (no trade today, can use Prev): $zeroClose"

$reader.Dispose()
$stream.Dispose()
$zip.Dispose()
