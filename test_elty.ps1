try {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    try {
        Invoke-WebRequest -Uri "https://fc.yahoo.com" -WebSession $session -UserAgent "Mozilla/5.0" -TimeoutSec 5 -ErrorAction SilentlyContinue
    } catch {}
    
    $crumb = Invoke-RestMethod -Uri "https://query1.finance.yahoo.com/v1/test/getcrumb" -WebSession $session -UserAgent "Mozilla/5.0" -TimeoutSec 5
    
    $url = "https://query1.finance.yahoo.com/v10/finance/quoteSummary/ELTY.JK?modules=defaultKeyStatistics,financialData&crumb=$crumb"
    $res = Invoke-RestMethod -Uri $url -WebSession $session -UserAgent "Mozilla/5.0" -TimeoutSec 5
    $stat = $res.quoteSummary.result[0].defaultKeyStatistics
    $fin = $res.quoteSummary.result[0].financialData
    Write-Host "ELTY.JK Success!" -ForegroundColor Green
    Write-Host "EPS: $($stat.trailingEps.raw)"
    Write-Host "Book Value: $($stat.bookValue.raw)"
    Write-Host "Shares Outstanding: $($stat.sharesOutstanding.raw)"
    Write-Host "Total Revenue: $($fin.totalRevenue.raw)"
    Write-Host "Return on Equity: $($fin.returnOnEquity.raw)"
    Write-Host "Operating Cashflow: $($fin.operatingCashflow.raw)"
} catch {
    Write-Host "ELTY test error: $($_.Exception.Message)"
}
