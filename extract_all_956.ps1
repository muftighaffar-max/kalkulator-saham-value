$csv = curl.exe -s -L "https://raw.githubusercontent.com/aryakdaniswara/idx-stock-ownership/main/data/kepemilikan_saham_20260227.csv" | ConvertFrom-Csv

$map = @{}
foreach ($row in $csv) {
    $code = $row.share_code.Trim().ToUpper()
    $name = $row.issuer_name.Trim()
    if ($code.Length -eq 4 -and -not $map.ContainsKey($code)) {
        $map[$code] = $name
    }
}

Write-Host "Total emiten 4 huruf tersimpan: $($map.Count)" -ForegroundColor Green

$json = $map | ConvertTo-Json
$json | Out-File -FilePath "D:\gemini\kalkulator-saham\master_956_saham.json" -Encoding utf8
Write-Host "File master_956_saham.json berhasil dibuat di D:\gemini\kalkulator-saham\!" -ForegroundColor Cyan
