try {
    $targetUrl = [System.Uri]::EscapeDataString("https://query1.finance.yahoo.com/v8/finance/chart/ELTY.JK?interval=1d&range=1d")
    $proxyUrl = "https://api.allorigins.win/raw?url=$targetUrl"
    $res = Invoke-RestMethod -Uri $proxyUrl -TimeoutSec 7
    Write-Host "Allorigins proxy success for ELTY: $($res.chart.result[0].meta.symbol)" -ForegroundColor Green
} catch {
    Write-Host "Allorigins error: $($_.Exception.Message)"
}
