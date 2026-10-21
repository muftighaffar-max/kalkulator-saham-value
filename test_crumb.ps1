try {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    try {
        Invoke-WebRequest -Uri "https://fc.yahoo.com" -WebSession $session -UserAgent "Mozilla/5.0" -TimeoutSec 5 -ErrorAction SilentlyContinue
    } catch {}
    
    $crumb = Invoke-RestMethod -Uri "https://query1.finance.yahoo.com/v1/test/getcrumb" -WebSession $session -UserAgent "Mozilla/5.0" -TimeoutSec 5
    Write-Host "Crumb obtained: $crumb" -ForegroundColor Green
    
    $url = "https://query1.finance.yahoo.com/v10/finance/quoteSummary/BBCA.JK?modules=defaultKeyStatistics,financialData&crumb=$crumb"
    $res = Invoke-RestMethod -Uri $url -WebSession $session -UserAgent "Mozilla/5.0" -TimeoutSec 5
    $stat = $res.quoteSummary.result[0].defaultKeyStatistics
    Write-Host "EPS: $($stat.trailingEps.raw), BVPS: $($stat.bookValue.raw)" -ForegroundColor Green
} catch {
    Write-Host "Crumb test error: $($_.Exception.Message)"
}
