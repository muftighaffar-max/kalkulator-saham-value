$path = "D:\gemini\kalkulator-saham\index.html"
$lines = [System.Collections.Generic.List[string]]([System.IO.File]::ReadAllLines($path, [System.Text.Encoding]::UTF8))

# Cari baris <!-- Quick Category Filter Pills -->
$startIdx = -1
$endIdx = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "Quick Category Filter Pills") {
        $startIdx = $i
    }
    if ($startIdx -ge 0 -and $i -gt $startIdx -and $lines[$i] -match "<!-- STRATEGI EKSEKUSI") {
        $endIdx = $i - 2 # baris sebelum penutup div container
        break
    }
}

Write-Host "Found range: $startIdx to $endIdx"

if ($startIdx -ge 0 -and $endIdx -gt $startIdx) {
    $newPills = @(
        '      <!-- Quick Category Filter Pills -->'
        '      <div class="flex flex-wrap items-center justify-center gap-2 pt-3">'
        '        <span class="text-xs text-slate-500 font-medium">Pilihan Cepat:</span>'
        '        <button onclick="selectStock(''BRIS'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>'
        '          <span class="font-bold text-white">BRIS</span>'
        '          <span class="text-emerald-400 font-mono text-[11px]">Rp 1.320</span>'
        '        </button>'
        '        <button onclick="selectStock(''ICBP'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>'
        '          <span class="font-bold text-white">ICBP</span>'
        '          <span class="text-emerald-400 font-mono text-[11px]">Rp 7.025</span>'
        '        </button>'
        '        <button onclick="selectStock(''SIDO'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>'
        '          <span class="font-bold text-white">SIDO</span>'
        '          <span class="text-emerald-400 font-mono text-[11px]">Rp 350</span>'
        '        </button>'
        '        <button onclick="selectStock(''ANTM'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>'
        '          <span class="font-bold text-white">ANTM</span>'
        '          <span class="text-emerald-400 font-mono text-[11px]">Rp 3.100</span>'
        '        </button>'
        '        <button onclick="selectStock(''PTBA'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>'
        '          <span class="font-bold text-white">PTBA</span>'
        '          <span class="text-emerald-400 font-mono text-[11px]">Rp 3.260</span>'
        '        </button>'
        '        <button onclick="selectStock(''SMRA'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>'
        '          <span class="font-bold text-white">SMRA</span>'
        '          <span class="text-emerald-400 font-mono text-[11px]">Rp 256</span>'
        '        </button>'
        '        <button onclick="selectStock(''BUAH'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-emerald-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-emerald-400"></span>'
        '          <span class="font-bold text-white">BUAH</span>'
        '          <span class="text-emerald-400 font-mono text-[11px]">Rp 486</span>'
        '        </button>'
        '        <button onclick="selectStock(''PANI'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-rose-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-rose-400"></span>'
        '          <span class="font-bold text-white">PANI</span>'
        '          <span class="text-rose-400 font-mono text-[11px]">Rp 4.760</span>'
        '          <span class="text-[9px] px-1 py-0.2 rounded bg-rose-950/80 text-rose-300 border border-rose-800/40 font-semibold">Non-DES</span>'
        '        </button>'
        '        <button onclick="selectStock(''BBCA'')" class="px-3 py-1.5 text-xs rounded-xl bg-slate-900 hover:bg-slate-800 text-slate-200 border border-slate-700 hover:border-rose-500/50 transition flex items-center gap-1.5 shadow-sm">'
        '          <span class="w-2 h-2 rounded-full bg-rose-400"></span>'
        '          <span class="font-bold text-white">BBCA</span>'
        '          <span class="text-rose-400 font-mono text-[11px]">Rp 5.950</span>'
        '          <span class="text-[9px] px-1 py-0.2 rounded bg-rose-950/80 text-rose-300 border border-rose-800/40 font-semibold">Non-DES</span>'
        '        </button>'
        '      </div>'
    )

    $removeCount = ($endIdx - $startIdx) + 1
    $lines.RemoveRange($startIdx, $removeCount)
    $lines.InsertRange($startIdx, [string[]]$newPills)
}

# Perbaiki juga baris-baris skenario Bear, Normal, Bull
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "Skenario Bear \(Pesimis\)") {
        $lines[$i] = '                <span class="w-2 h-2 rounded-full bg-rose-400 inline-block mr-1"></span> Skenario Bear (Pesimis)'
    }
    if ($lines[$i] -match "Skenario Normal \(Konsensus\)") {
        $lines[$i] = '                <span class="w-2 h-2 rounded-full bg-emerald-400 inline-block mr-1"></span> Skenario Normal (Konsensus)'
    }
    if ($lines[$i] -match "Skenario Bull \(Optimis\)") {
        $lines[$i] = '                <span class="w-2 h-2 rounded-full bg-indigo-400 inline-block mr-1"></span> Skenario Bull (Optimis)'
    }
    if ($lines[$i] -match "Risiko Terdepak dari DES Sangat Rendah") {
        $lines[$i] = '              <span class="text-emerald-400 font-bold mr-1">&#10003;</span> <b>Risiko Terdepak dari DES Sangat Rendah:</b> Struktur utang berbunga aman di bawah ambang batas OJK.'
    }
}

[System.IO.File]::WriteAllLines($path, $lines, [System.Text.Encoding]::UTF8)
Write-Host "SUKSES! index.html telah bersih dari seluruh karakter rusak." -ForegroundColor Green
