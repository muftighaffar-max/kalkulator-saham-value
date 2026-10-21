try {
    $url = "https://query1.finance.yahoo.com/v10/finance/quoteSummary/BBCA.JK?modules=financialData,defaultKeyStatistics,summaryDetail"
    $headers = @{ "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }
    $res = Invoke-RestMethod -Uri $url -Headers $headers -TimeoutSec 7
    $q = $res.quoteSummary.result[0]
    Write-Host "BBCA.JK Success!" -ForegroundColor Green
    Write-Host "Trailing EPS: $($q.defaultKeyStatistics.trailingEps.raw)"
    Write-Host "Book Value: $($q.defaultKeyStatistics.bookValue.raw)"
    Write-Host "Return on Equity: $($q.financialData.returnOnEquity.raw)"
    Write-Host "Total Revenue: $($q.financialData.totalRevenue.raw)"
    Write-Host "Operating Cashflow: $($q.financialData.operatingCashflow.raw)"
} catch {
    Write-Host "Fetch test error: $($_.Exception.Message)" -ForegroundColor Yellow
}
