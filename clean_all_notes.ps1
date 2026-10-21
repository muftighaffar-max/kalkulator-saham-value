$path = "D:\gemini\kalkulator-saham\index.html"
$lines = [System.IO.File]::ReadAllLines($path, [System.Text.Encoding]::UTF8)

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "Kualitas Laba Sangat Tinggi") {
        $lines[$i] = '        noteBox.innerHTML = `<span class="text-emerald-400 font-bold mr-1">&#10003;</span> <b>Kualitas Laba Sangat Tinggi:</b> Setiap Rp 1 laba bersih menghasilkan <b>Rp ${s.cfoToEps.toFixed(2)} uang kas nyata</b>. Bebas dari manipulasi piutang dan dividen terbukti dibayar dari kas riil.`;'
    }
    if ($lines[$i] -match "Arus Kas Sehat:") {
        $lines[$i] = '        noteBox.innerHTML = `<span class="text-teal-400 font-bold mr-1">&#9878;</span> <b>Arus Kas Sehat:</b> Arus kas operasional berjalan stabil dan sejalan dengan siklus modal kerja normal perusahaan.`;'
    }
    if ($lines[$i] -match "Perhatikan Arus Kas:") {
        $lines[$i] = '        noteBox.innerHTML = `<span class="text-amber-400 font-bold mr-1">&#9888;</span> <b>Perhatikan Arus Kas:</b> Kas operasional lebih rendah dari laba akuntansi (${s.cfoToEps.toFixed(2)}x). Kemungkinan uang kas sedang tertahan di piutang atau belanja modal pabrik besar.`;'
    }
    if ($lines[$i] -match "Status Syariah Terjaga:") {
        $lines[$i] = '        alertBox.innerHTML = `<span class="text-teal-400 font-bold mr-1">&#9878;</span> <b>Status Syariah Terjaga:</b> Rasio utang ${s.debtRatio.toFixed(1)}% masih memenuhi syarat OJK, namun perlu dipantau tiap semester saat emiten menerbitkan pinjaman baru.`;'
    }
    if ($lines[$i] -match "PERINGATAN DINI \(EARLY WARNING\):") {
        $lines[$i] = '        alertBox.innerHTML = `<span class="text-amber-400 font-bold mr-1">&#9888;</span> <b>PERINGATAN DINI (EARLY WARNING):</b> Utang berbunga sudah mencapai ${s.debtRatio.toFixed(1)}%! Jika aset menyusut, saham ini <b>berisiko terdepak dari Daftar Efek Syariah (DES)</b> pada evaluasi OJK berikutnya.`;'
    }
}

[System.IO.File]::WriteAllLines($path, $lines, [System.Text.Encoding]::UTF8)
Write-Host "Berhasil membersihkan seluruh teks catatan dan alert!" -ForegroundColor Green
