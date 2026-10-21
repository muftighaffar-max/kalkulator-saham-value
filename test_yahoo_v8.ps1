try {
    $url = "https://query1.finance.yahoo.com/v8/finance/chart/BBCA.JK?interval=1d&range=5d"
    $headers = @{ "User-Agent" = "Mozilla/5.0" }
    $res = Invoke-RestMethod -Uri $url -Headers $headers -TimeoutSec 7
    Write-Host "v8 chart works!" -ForegroundColor Green
    Write-Host "Symbol: $($res.chart.result[0].meta.symbol)"
    Write-Host "Currency: $($res.chart.result[0].meta.currency)"
} catch {
    Write-Host "v8 chart error: $($_.Exception.Message)"
}
