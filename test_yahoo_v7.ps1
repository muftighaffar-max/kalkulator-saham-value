try {
    $url = "https://query1.finance.yahoo.com/v7/finance/quote?symbols=BBCA.JK,ELTY.JK"
    $headers = @{ "User-Agent" = "Mozilla/5.0" }
    $res = Invoke-RestMethod -Uri $url -Headers $headers -TimeoutSec 7
    $q = $res.quoteResponse.result[0]
    Write-Host "v7 quote works!" -ForegroundColor Green
    Write-Host "Symbol: $($q.symbol)"
    Write-Host "EPS Trailing: $($q.epsTrailingTwelveMonths)"
    Write-Host "Book Value: $($q.bookValue)"
    Write-Host "PE: $($q.trailingPE)"
    Write-Host "PBV: $($q.priceToBook)"
    Write-Host "Market Cap: $($q.marketCap)"
    Write-Host "Shares Outstanding: $($q.sharesOutstanding)"
} catch {
    Write-Host "v7 quote error: $($_.Exception.Message)"
}
