Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('D:\Downloads\Ringkasan Saham-20261013 (1).xlsx')
$entry = $zip.GetEntry('xl/worksheets/sheet1.xml')
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream)
$xml = [xml]$reader.ReadToEnd()
$row1 = $xml.worksheet.sheetData.row | Where-Object { $_.r -eq '1' }
foreach ($cell in $row1.c) {
    Write-Output "$($cell.r) : $($cell.v)"
}
$reader.Dispose()
$stream.Dispose()
$zip.Dispose()
